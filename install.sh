#!/bin/bash 

if [ -f ~/.xinitrc ]; then
    echo $PWD/dynamic_swap.sh >> ~/.xinitrc
    echo -e "##########\nDynamic swap installed successfully.\n##########"
elif [ -d ~/.config/autostart ]; then
    cp dynamic_swap.sh ~/.config/autostart
    echo -e "##########\nDynamic swap installed successfully.\n##########"
else
    echo -e "##########\nThe installer failed to make the script start on boot. Do it manually.\n##########"
fi
