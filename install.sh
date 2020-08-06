#!/bin/bash 

if [ -f ~/.xinitrc ]; then
    echo -e "##########\nInstalling dynamic swap.\n##########"
    echo $PWD/dynamic_swap.sh >> ~/.xinitrc
elif [ -d ~/.config/autostart ]; then
    echo -e "##########\nInstalling dynamic swap.\n##########"
    cp dynamic_swap.sh ~/.config/autostart
else
    echo -e "##########\nThe installer failed to make the script start on boot. Do it manually.\n##########"
fi
