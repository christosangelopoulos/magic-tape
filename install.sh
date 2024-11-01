#! /bin/bash
#make script executable, copy it to the #PATH
chmod +x magic-tape.sh
cp magic-tape.sh ~/.local/bin/

#create the necessary directories:
mkdir -p ~/.cache/magic-tape/history/ ~/.cache/magic-tape/jpg/ ~/.cache/magic-tape/json/ ~/.cache/magic-tape/search/video/ ~/.cache/magic-tape/comments/
mkdir -p ~/.cache/magic-tape/search/channels/ ~/.cache/magic-tape/subscriptions/jpg/ ~/.config/magic-tape/ ~/.local/share/magic-tape/
touch ~/.cache/magic-tape/history/watch_history.txt ~/.cache/magic-tape/subscriptions/subscriptions.txt
cp -r png/ ~/.local/share/magic-tape/
cp magic-tape.conf ~/.config/magic-tape/
clear
echo -e "magic-tape has been install successfully. You can run magic-tape from the same directory with\n$ ./magic-tape.sh\nor, provided that $HOME/.local/bin/ is added to the \$PATH, with just\n$ magic-tape.sh\nEnjoy!"
