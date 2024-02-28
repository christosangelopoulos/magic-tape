#! /bin/bash
#make script executable, copy it to the #PATH
chmod +x magic-tape.sh
cp magic-tape.sh ~/.local/bin/

#create the necessary directories:
mkdir -p ~/.cache/magic-tape/history/ ~/.cache/magic-tape/jpg/ ~/.cache/magic-tape/json/ ~/.cache/magic-tape/search/video/
mkdir -p ~/.cache/magic-tape/search/channels/ ~/.cache/magic-tape/subscriptions/jpg/ ~/.config/magic-tape/
cp -r png/ ~/.cache/magic-tape/png/
cp magic-tape.conf ~/.config/magic-tape/
