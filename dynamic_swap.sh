#!/bin/bash

ssd=true
path=/.swapfiles
name="swapfile-"

size=$1
block=$2

i=0

function init {
    if ! [ -d $path ]
    then
        mkdir $path
    fi
    
    cd $path
    
    if ! $ssd
    then
        rm *
    fi
}

function enable_swap {
    ((++i))
    if ! [ -f "$name$i" ]
    then
        dd if=/dev/zero of=$path/$name$i count=$size bs=$block
        chmod 600 $name$i
        mkswap $name$i
    fi
    swapon $name$i
}

function disable_swap {
    swapoff $name$i
    if ! $ssd
    then
        rm $name$i
    fi
    ((--i))
}

init
while true
do
    swappiness=$(sysctl vm.swappiness | awk '/^vm.swappiness/{print $3/100}')

    memtotal=$(free -m | awk '/^Mem/{print $2}')
    memfree=$(free -m | awk '/^Mem/{print $4}')
    
    swaptotal=$(free -m | awk '/^Swap/{print $2}')
    swapfree=$(free -m | awk '/^Swap/{print $4}')

    if (( $(echo "$memtotal * $swappiness > $memfree" | bc) && $(echo "$swaptotal * $swappiness >= $swapfree" | bc) ))
    then
        enable_swap
    fi
    
    if (( $(echo "$swapfree - $size * (1 + $swappiness) > $swaptotal * $swappiness" | bc) && $(echo "$i >= 1" | bc) ))
    then
        disable_swap
    fi
    
    sleep 10s
done
