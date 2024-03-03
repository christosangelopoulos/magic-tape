#! /bin/bash
#┏┳┓┏━┓┏━╸╻┏━╸   ╺┳╸┏━┓┏━┓┏━╸
#┃┃┃┣━┫┃╺┓┃┃  ╺━╸ ┃ ┣━┫┣━┛┣╸
#╹ ╹╹ ╹┗━┛╹┗━╸    ╹ ╹ ╹╹  ┗━╸
#A script written by Christos Angelopoulos in March 2023 under GNU GENERAL PUBLIC LICENSE
#
function load_config() {
 PREF_SELECTOR="$(grep 'PREF_SELECTOR:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 PREF_BROWSER="$(grep 'PREF_BROWSER:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 LINK_BROWSER="$(grep 'LINK_BROWSER:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 LIST_LENGTH="$(grep 'LIST_LENGTH:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 TERMINAL_MESSAGE_DURATION="$(grep 'TERMINAL_MESSAGE_DURATION:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 COLORED_MESSAGES="$(grep 'COLORED_MESSAGES:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 NOTIFICATION_DURATION="$(grep 'NOTIFICATION_DURATION:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 IMAGE_SUPPORT="$(grep 'IMAGE_SUPPORT:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 SHOW_MPV_KEYBINDINGS="$(grep 'SHOW_MPV_KEYBINDINGS:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 PREF_EDITOR="$(grep 'PREF_EDITOR:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 DOWNLOAD_DIRECTORY="$(grep 'DOWNLOAD_DIRECTORY:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 if [[ $COLORED_MESSAGES == "yes" ]];
 then  GreenInvert="$(grep "GreenInvert:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
  Yellow="$(grep "Yellow:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
  Green="$(grep "Green:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')" ;
  Red="$(grep "Red:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
  Magenta="$(grep "Magenta:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
  Cyan="$(grep "Cyan:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
  Black="$(grep "Black:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
  Gray="$(grep "Gray:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
  bold="$(grep "bold:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
  normal="$(grep "normal:" ~/.config/magic-tape/magic-tape.conf |sed 's/^#.*//g;s/^.*: //')";
 else GreenInvert="";
  Yellow="";
  Green="";
  Red="" ;
  Magenta="" ;
  Cyan="" ;
  Black="" ;
  Gray="" ;
  bold="" ;
  normal="" ;fi;
 ROFI_FORMAT="$(grep 'rofi_format' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/rofi_format//;s/|//')";
 FZF_FORMAT="$(grep 'fzf_format' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/fzf_format//;s/|//')";
 DMENU_FORMAT="$(grep 'dmenu_format' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/dmenu_format//;s/|//')";
	if [[ $PREF_SELECTOR == "rofi" ]]
	then PREF_SELECTOR="$ROFI_FORMAT"
	elif [[ $PREF_SELECTOR == "fzf" ]]
	then PREF_SELECTOR="$FZF_FORMAT"
	elif [[ $PREF_SELECTOR == "dmenu" ]]
	then PREF_SELECTOR=""$DMENU_FORMAT""
	fi;
}

function search_filter ()
{
 FILT_PROMPT="";
 FILT_PROMPT="$(echo -e "No Duration Filter\n☕ Duration up to 4 mins\n☕☕ Duration between 4 and 20 mins\n☕☕☕ Duration longer than 20 mins\n📋 Search for playlist"|eval "$PREF_SELECTOR""\"Select Filter \"")";
 case $FILT_PROMPT in
  "No Duration Filter") FILTER="&sp=EgQQARgE";
  ;;
  "☕ Duration up to 4 mins") FILTER="&sp=EgQQARgB";
  ;;
  "☕☕ Duration between 4 and 20 mins") FILTER="&sp=EgQQARgD";
  ;;
  "☕☕☕ Duration longer than 20 mins") FILTER="&sp=EgQQARgC";
  ;;
  "📋 Search for playlist") FILTER="&sp=EgQQAxgE";
  ;;
  *)FILTER="&sp=EgQQARgE";
  ;;
 esac
}

function new_subscription ()
{
  C=${C// /+};C=${C//\'/%27};
  repeat_channel_search=1;
  ITEM=1;
  FEED="/results?search_query="$C"&sp=EgIQAg%253D%253D";
  while [ $repeat_channel_search -eq 1 ];
  do fzf_header="$(echo ${FEED^^}|sed 's/&SP=.*$//;s/^.*SEARCH_QUERY=/search: /;s/[\/\?=&+]/ /g') channels: $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
  ITEM0=$ITEM;
  echo -e "${Green}Downloading${Yellow}${bold} $FEED...${normal}";
  echo -e "$db\n$ITEM\n$ITEM0\n$FEED\n$fzf_header">$HOME/.cache/magic-tape/history/last_action.txt;
  yt-dlp --cookies-from-browser $PREF_BROWSER --flat-playlist --playlist-start $ITEM --playlist-end $(($ITEM + $(($LIST_LENGTH - 1)))) -j "https://www.youtube.com$FEED">$HOME/.cache/magic-tape/json/channel_search.json
  echo -e "${Green}Completed${Yellow}${bold} $FEED${normal}";

  jq '.channel_id' $HOME/.cache/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/.cache/magic-tape/search/channels/ids.txt;
  jq '.title' $HOME/.cache/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/.cache/magic-tape/search/channels/titles.txt;
  jq '.description' $HOME/.cache/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/.cache/magic-tape/search/channels/descriptions.txt;
  jq '.channel_follower_count' $HOME/.cache/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/.cache/magic-tape/search/channels/subscribers.txt;
  jq '.thumbnails[1].url' $HOME/.cache/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/.cache/magic-tape/search/channels/img_urls.txt;

  cat /dev/null>$HOME/.cache/magic-tape/search/channels/thumbnails.txt;
  i=1;
   while [ $i -le $(cat $HOME/.cache/magic-tape/search/channels/ids.txt|wc -l) ];
   do  echo "url = \"https:""$(cat $HOME/.cache/magic-tape/search/channels/img_urls.txt|head -$i|tail +$i)\"">>$HOME/.cache/magic-tape/search/channels/thumbnails.txt;
   echo "output = \"$HOME/.cache/magic-tape/jpg/$(cat $HOME/.cache/magic-tape/search/channels/ids.txt|head -$i|tail +$i).jpg\"">>$HOME/.cache/magic-tape/search/channels/thumbnails.txt;
   ((i++));
  done;
  echo -e "${Green}Downloading channel thumbnails...${normal}";
  curl -s -K $HOME/.cache/magic-tape/search/channels/thumbnails.txt&echo -e "${Yellow}${bold}[Background downloading channel thumbnails]${normal}";
  if [ $ITEM -gt 1 ];then echo "Previous Page">>$HOME/.cache/magic-tape/search/channels/titles.txt;fi;
  if [ $(cat $HOME/.cache/magic-tape/search/channels/ids.txt|wc -l) -ge $LIST_LENGTH ];then echo "Next Page">>$HOME/.cache/magic-tape/search/channels/titles.txt;fi;
  echo "Abort Selection">>$HOME/.cache/magic-tape/search/channels/titles.txt;

  CHAN=" $(cat -n $HOME/.cache/magic-tape/search/channels/titles.txt|sed 's/^. *//g' |fzf\
  --info=hidden \
  --layout=reverse \
  --height=100% \
  --prompt="Select Channel: " \
  --header="$fzf_header" \
  --preview-window=left,50%\
  --bind=right:accept \
  --expect=shift-left,shift-right\
  --tabstop=1 \
  --no-margin  \
  +m \
  -i \
  --exact \
  --preview='height=$(($FZF_PREVIEW_COLUMNS/2 +2));\
  i=$(echo {}|sed "s/\\t.*$//g");\
  echo $i>$HOME/.cache/magic-tape/search/channels/index.txt;\
  TITLE="$(cat $HOME/.cache/magic-tape/search/channels/titles.txt|head -$i|tail +$i)";\
  if [[ "$IMAGE_SUPPORT" != "none" ]]&&[[ "$IMAGE_SUPPORT" != "chafa" ]];then ll=0;while [ $ll -le $(($height/2 - 2)) ];do echo "";((ll++));done;fi;\
  ll=1; echo -ne "\x1b[38;5;241m"; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n -e "─";((ll++));done;echo -n -e "$normal";\
  if [[ "$TITLE" == "Previous Page" ]];then draw_preview $(($height/3)) 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/.cache/magic-tape/png/previous.png;\
  elif [[ "$TITLE" == "Next Page" ]];then draw_preview $(($height/3)) 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/.cache/magic-tape/png/next.png;\
  elif [[ "$TITLE" == "Abort Selection" ]];then draw_preview $(($height/3)) 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/.cache/magic-tape/png/abort.png;\
  else draw_preview $(($height/3)) 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/.cache/magic-tape/jpg/"$(cat $HOME/.cache/magic-tape/search/channels/ids.txt|head -$i|tail +$i)".jpg;fi;\
  echo -e "\n""$Yellow""$TITLE""$normal"|fold -w $FZF_PREVIEW_COLUMNS -s;\
  ll=1; echo -ne "\x1b[38;5;241m"; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n -e "─";((ll++));done;echo -n -e "$normal";\
   if [[ $TITLE != "Abort Selection" ]]&&[[ $TITLE != "Next Page" ]]&&[[ $TITLE != "Previous Page" ]];\
   then SUBS="$(cat $HOME/.cache/magic-tape/search/channels/subscribers.txt|head -$i|tail +$i)";\
  echo -e "\n"$Green"Subscribers: ""$Cyan""$SUBS""$normal";\
  ll=1; echo -ne "\x1b[38;5;241m"; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n -e "─";((ll++));done;echo -n -e "$normal";\
  DESCRIPTION="$(cat $HOME/.cache/magic-tape/search/channels/descriptions.txt|head -$i|tail +$i)";\
  echo -e "\n\x1b[38;5;250m$DESCRIPTION"$normal""|fold -w $FZF_PREVIEW_COLUMNS -s; \
  fi;')";
  clear_image;
  i=$(cat $HOME/.cache/magic-tape/search/channels/index.txt);
  NAME=$(head -$i $HOME/.cache/magic-tape/search/channels/titles.txt|tail +$i);
  if [[ $CHAN == " " ]]; then echo "ABORT!"; NAME="Abort Selection";clear;fi;
  echo -e "${Green}Channel Selected: ${Yellow}${bold}$NAME${normal}";
  if [ $ITEM  -ge $LIST_LENGTH ]&&[[ $CHAN == *"shift-left"* ]]; then NAME="Previous Page";fi;
  if [ $ITEM  -le $LIST_LENGTH ]&&[[ $CHAN == *"shift-left"* ]]; then NAME="Abort Selection";fi;
  #if [[ -n $PREVIOUS_PAGE ]]&&[[ $CHAN == *"shift-left"* ]]; then NAME="Previous Page";fi;
  if [[ $CHAN == *"shift-right"* ]]; then NAME="Next Page";fi;
  if [[ $NAME == "Next Page" ]];then ITEM=$(($ITEM + $LIST_LENGTH));fi;
  if [[ $NAME == "Previous Page" ]];then ITEM=$(($ITEM - $LIST_LENGTH));fi;
  if [[ $NAME == "Abort Selection" ]];then repeat_channel_search=0;fi;
  if [[ "$NAME" != "Abort Selection" ]]&&[[ "$NAME" != "Next Page" ]]&&[[ "$NAME" != "Previous Page" ]];
  then SUB_URL="$(head -$i $HOME/.cache/magic-tape/search/channels/ids.txt|tail +$i)";
   repeat_channel_search=0;
   echo -e " ${Green}You will subscribe to this channel:\n${Yellow}${bold}$NAME${normal}\nProceed?(Y/y)"; read -N 1 pr;echo -e "\n";
   if [[ $pr == Y ]] || [[ $pr == y ]];
   then  notification_img="$HOME/.cache/magic-tape/jpg/""$(cat $HOME/.cache/magic-tape/search/channels/ids.txt|head -$i|tail +$i)"".jpg";
    if [ -n "$(grep -i $SUB_URL $HOME/.cache/magic-tape/subscriptions/subscriptions.txt)" ];
    then notify-send -t $NOTIFICATION_DURATION -i "$notification_img" "You are already subscribed to $NAME ";
    else echo "$SUB_URL"" ""$NAME">>$HOME/.cache/magic-tape/subscriptions/subscriptions.txt;
     notify-send -t $NOTIFICATION_DURATION -i "$notification_img" "You have subscribed to $NAME ";
     mv "$notification_img" $HOME/.cache/magic-tape/subscriptions/jpg/"$SUB_URL.jpg";
     echo -e "${Red}${bold}NOTICE: ${Yellow}${bold}In order for this action to take effect in YouTube, you need to subscribe manually from a browser as well.\nDo you want to do it now? (Y/y)${normal}"|fold -w 75 -s;
     read -N 1 pr2;echo -e "\n";
     if [[ $pr2 == Y ]] || [[ $pr2 == y ]];then $LINK_BROWSER "https://www.youtube.com/channel/"$SUB_URL&echo "Opened $LINK_BROWSER";fi;
    fi;
   fi;
  fi;
  done;
}

function channel_feed ()
{
  big_loop=1;
   ITEM=1;
   ITEM0=$ITEM;
   if [[ "$P" == "@"* ]];then FEED="/""$P""/videos";else FEED="/channel/""$P""/videos";fi
   while [ $big_loop -eq 1 ];
   do fzf_header="channel: "$channel_name"  videos $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
   get_feed_json;
   get_data;
   small_loop=1;
   while [ $small_loop -eq 1 ];
   do select_video ;
    if [[ "$TITLE" == "Next Page" ]]||[[ "$TITLE" == "Previous Page" ]];then small_loop=0;fi;
    if [[ "$TITLE" == "Abort Selection" ]];then small_loop=0;big_loop=0;fi;
    if [[ "$TITLE" != "Abort Selection" ]]&&[[ "$TITLE" != "Next Page" ]]&&[[ "$TITLE" != "Previous Page" ]];then select_action;fi;
   done;
  done;
}

function like_video ()
{
 LIKE="$(tac $HOME/.cache/magic-tape/history/watch_history.txt|sed 's/^.*https:\/\/www\.youtube\.com/https:\/\/www\.youtube\.com/g'|cut -d' ' -f2-|eval "$PREF_SELECTOR""\"❤️ Select video to like \"")";
 if [[ -z "$LIKE" ]];
  then empty_query;
 else echo -e "❤️ Add\n${Yellow}${bold}"$LIKE"${normal}\nto Liked Videos?(Y/y))";
  read -N 1 alv;echo -e "\n";
  if [[ $alv == Y ]] || [[ $alv == y ]];
  then if [[ -z "$(grep "$LIKE" $HOME/.cache/magic-tape/history/liked.txt)" ]];
   then echo "$(grep "$LIKE" $HOME/.cache/magic-tape/history/watch_history.txt|head -1)" >> $HOME/.cache/magic-tape/history/liked.txt;
    notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "❤️ Video added to Liked Videos.";
   else notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "❤️ Video already added to Liked Videos.";
   fi;
  fi;alv="";
 fi;
}

function import_subscriptions()
{
 echo -e "Your magic-tape subscriptions will be synced with your YouTube ones.Before initializing this function, make sure you are logged in in your YT account, and you have set up your preferred browser.\nProceed? (Y/y)"|fold -w 75 -s;
 read -N 1 impsub ;echo -e "\n";
 if [[ $impsub == "Y" ]] || [[ $impsub == "y" ]];
 then  echo -e "${Green}Downloading subscriptions data...${normal}";
  new_subs=subscriptions_$(date +%F).json;
  yt-dlp --cookies-from-browser $PREF_BROWSER --flat-playlist -j "https://www.youtube.com/feed/channels">$HOME/.cache/magic-tape/json/$new_subs;
  echo -e "${Green}Download Complete.${normal}";
  jq '.id' $HOME/.cache/magic-tape/json/$new_subs|sed 's/"//g'>$HOME/.cache/magic-tape/search/channels/channel_ids.txt;
  jq '.title' $HOME/.cache/magic-tape/json/$new_subs|sed 's/"//g'>$HOME/.cache/magic-tape/search/channels/channel_names.txt;
  jq '.thumbnails[1].url' $HOME/.cache/magic-tape/json/$new_subs|sed 's/"//g'>$HOME/.cache/magic-tape/search/channels/image_urls.txt;
  cat /dev/null>$HOME/.cache/magic-tape/search/channels/thumbnails.txt;
  cp $HOME/.cache/magic-tape/subscriptions/subscriptions.txt $HOME/.cache/magic-tape/subscriptions/subscriptions-$(date +%F).bak.txt;
  cat /dev/null>$HOME/.cache/magic-tape/subscriptions/subscriptions.txt;
  i=1;
  while [ $i -le $(cat $HOME/.cache/magic-tape/search/channels/channel_ids.txt|wc -l) ];
  do echo "$(cat $HOME/.cache/magic-tape/search/channels/channel_ids.txt|head -$i|tail +$i) $(cat $HOME/.cache/magic-tape/search/channels/channel_names.txt|head -$i|tail +$i)">>$HOME/.cache/magic-tape/subscriptions/subscriptions.txt;
   img_path="$HOME/.cache/magic-tape/subscriptions/jpg/$(cat $HOME/.cache/magic-tape/search/channels/channel_ids.txt|head -$i|tail +$i).jpg";
   if [ ! -f  "$img_path" ];
   then echo "url = \"https:$(cat $HOME/.cache/magic-tape/search/channels/image_urls.txt|head -$i|tail +$i)\"">>$HOME/.cache/magic-tape/search/channels/thumbnails.txt;
    echo "output = \"$img_path\"">>$HOME/.cache/magic-tape/search/channels/thumbnails.txt;
   fi;
   ((i++));
  done;
  echo -e "${Green}Downloading thumbnails...${normal}";
  curl -s -K $HOME/.cache/magic-tape/search/channels/thumbnails.txt;
  echo -e "${Green}Thumbnail download complete.${normal}";
  echo -e "${Green}Your magic-tape subscriptions are now updated.\nA backup copy of your old subscriptions is kept in\n${Yellow}${bold}$HOME/.cache/magic-tape/subscriptions/subscriptions-$(date +%F).bak.txt${normal}\n${Green}Press any key to return to the miscellaneous menu: ${normal}";
  read -N 1  imp2;clear;mv $HOME/.cache/magic-tape/json/$new_subs $HOME/.local/share/Trash/files/;
 fi;
}

function print_mpv_video_shortcuts()
{
 echo -e "  ${Gray}╭─────┬──────────╮ ╭─────┬─────────────╮";
 echo -e "  ${Gray}│${Magenta}  ␣  ${Gray}│${Cyan}    Pause ${Gray}│ │${Magenta}  f  ${Gray}│${Cyan}  Fullscreen ${Gray}│";
 echo -e "  ${Gray}├─────┼──────────┤ ├─────┼─────────────┤";
 echo -e "  ${Gray}│${Magenta} 9 0 ${Gray}│${Cyan}   ↑↓ Vol ${Gray}│ │${Magenta}  s  ${Gray}│${Cyan}  Screenshot ${Gray}│";
 echo -e "  ${Gray}├─────┼──────────┤ ├─────┼─────────────┤";
 echo -e "  ${Gray}│${Magenta}  m  ${Gray}│${Cyan}     Mute ${Gray}│ │${Magenta} 1 2 ${Gray}│${Cyan}    Contrast ${Gray}│";
 echo -e "  ${Gray}├─────┼──────────┤ ├─────┼─────────────┤";
 echo -e "  ${Gray}│${Magenta} ← → ${Gray}│${Cyan} Skip 10\"${Gray} │ │${Magenta} 3 4 ${Gray}│${Cyan}  Brightness${Gray} │";
 echo -e "  ${Gray}├─────┼──────────┤ ├─────┼─────────────┤";
 echo -e "  ${Gray}│${Magenta} ↑ ↓ ${Gray}│${Cyan} Skip 60\"${Gray} │ │${Magenta} 7 8 ${Gray}│${Cyan}  Saturation${Gray} │";
 echo -e "  ${Gray}├─────┼──────────┤ ├─────┼─────────────┤";
 echo -e "  ${Gray}│${Magenta} , . ${Gray}│${Cyan}    Frame ${Gray}│ │${Magenta}  q  ${Gray}│${Red}        Quit ${Gray}│";
 echo -e "  ${Gray}╰─────┴──────────╯ ╰─────┴─────────────╯${Magenta}";
}

function print_mpv_audio_shortcuts()
{
 echo -e "  ${Gray}╭─────┬──────────╮";
 echo -e "  ${Gray}│${Magenta}  ␣  ${Gray}│${Cyan}    Pause ${Gray}│";
 echo -e "  ${Gray}├─────┼──────────┤";
 echo -e "  ${Gray}│${Magenta} 9 0 ${Gray}│${Cyan}   ↑↓ Vol ${Gray}│";
 echo -e "  ${Gray}├─────┼──────────┤";
 echo -e "  ${Gray}│${Magenta}  m  ${Gray}│${Cyan}     Mute ${Gray}│";
 echo -e "  ${Gray}├─────┼──────────┤";
 echo -e "  ${Gray}│${Magenta} ← → ${Gray}│${Cyan} Skip 10\"${Gray} │";
 echo -e "  ${Gray}├─────┼──────────┤";
 echo -e "  ${Gray}│${Magenta} ↑ ↓ ${Gray}│${Cyan} Skip 60\"${Gray} │";
 echo -e "  ${Gray}├─────┼──────────┤";
 echo -e "  ${Gray}│${Magenta}  q  ${Gray}│${Red}     Quit ${Gray}│";
 echo -e "  ${Gray}╰─────┴──────────╯${Magenta}";
}

function misc_menu ()
{
 while [ "$db2" != "q" ] ;
 do db2="$(echo -e "${Yellow}${bold}┏┳┓╻┏━┓┏━╸   ┏┳┓┏━╸┏┓╻╻ ╻${normal}\n${Yellow}${bold}┃┃┃┃┗━┓┃     ┃┃┃┣╸ ┃┗┫┃ ┃${normal}\n${Yellow}${bold}╹ ╹╹┗━┛┗━╸   ╹ ╹┗━╸╹ ╹┗━┛${normal}\n${Yellow}${bold}P ${Cyan}to SET UP PREFERENCES!${normal}\n${Yellow}${bold}l ${Red}to LIKE a video.${normal}\n${Yellow}${bold}L ${Red}to UNLIKE a video.${normal}\n${Yellow}${bold}I ${Green}to import subscriptions from YouTube.${normal}\n${Yellow}${bold}n ${Green}to subscribe to a new channel.${normal}\n${Yellow}${bold}u ${Green}to unsubscribe from a channel.${normal}\n${Yellow}${bold}H ${Magenta}to clear ${Yellow}watch${Magenta} history.${normal}\n${Yellow}${bold}S ${Magenta}to clear ${Yellow}search${Magenta} history.${normal}\n${Yellow}${bold}T ${Magenta}to clear ${Yellow}thumbnail${Magenta} cache.${normal}\n${Yellow}${bold}q${normal} ${Cyan}to quit this menu.${normal}"|fzf \
--preview-window=0 \
--disabled \
--reverse \
--ansi \
--tiebreak=begin \
 --border=rounded \
 +i \
 +m \
 --color='gutter:-1' \
 --nth=1 \
 --info=hidden \
 --header-lines=3 \
 --prompt="Enter:" \
 --header-first  \
 --expect=A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,1,2,3,4,5,6,7,8,9,0 )";
 db2="$(echo $db2|awk '{print $1}')";
  case $db2 in
   "P") eval $PREF_EDITOR $HOME/.config/magic-tape/magic-tape.conf;load_config;if [[ $IMAGE_SUPPORT == "ueberzugpp" ]];then trap exit_upp  HUP INT QUIT TERM EXIT ERR ABRT ;clean_upp; fi;clear_image;
   ;;
   "I") clear;
      import_subscriptions;
   ;;
   "n") clear;
      echo -e "🔎 Enter keyword/keyphrase for a channel to search for: \n\n";
      read  C;
      if [[ -z "$C" ]];
      then empty_query;
      else new_subscription;
      fi;
     ;;
     "u") clear;U="$(cat $HOME/.cache/magic-tape/subscriptions/subscriptions.txt|cut -d' ' -f2-|eval "$PREF_SELECTOR""\"❌ Unsubscribe from channel \"")";
        if [[ -z "$U" ]]; then empty_query;
        else echo "$U";
        echo -e "${Red}${bold}Unsubscribe from this channel:\n"${Yellow}$U"${normal}\nProceed?(Y/y))";
         read -N 1 uc;echo -e "\n";
         if [[ $uc == Y ]] || [[ $uc == y ]];
         then notification_img="$HOME/.cache/magic-tape/png/magic-tape.png";
          sed -i "/$U/d" $HOME/.cache/magic-tape/subscriptions/subscriptions.txt;
          echo -e "${Green}${bold}Unsubscribed from $U ]${normal}";
          notify-send -t $NOTIFICATION_DURATION -i "$notification_img" "You have unsubscribed from $U";
          echo -e "${Red}${bold}NOTICE: ${Yellow}${bold}In order for this action to take effect in YouTube, you need to unsubscribe manually from a browser as well.\nDo you want to do it now? (Y/y)${normal}"|fold -w 75 -s;
          read -N 1 uc2;echo -e "\n";
          if [[ $uc2 == Y ]] || [[ $uc2 == y ]];then $LINK_BROWSER "https://www.youtube.com/feed/channels"&echo "Opened $PREF_BROWSER";fi;
         fi;
        fi;uc="";uc2="";
   ;;
   "H") clear;echo -e "${Green}Clear ${Yellow}${bold}watch history?${normal}(Y/y))";
      read -N 1 cwh;echo -e "\n";
      if [[ $cwh == Y ]] || [[ $cwh == y ]];
      then cat /dev/null > $HOME/.cache/magic-tape/history/watch_history.txt;
       notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "Watch history cleared.";
      fi;cwh="";
   ;;
   "S") clear;echo -e "${Green}Clear ${Yellow}${bold}search history?${normal}(Y/y))";
      read -N 1 csh;echo -e "\n";
      if [[ $csh == Y ]] || [[ $csh == y ]];
      then cat /dev/null > $HOME/.cache/magic-tape/history/search_history.txt;
      notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "Search history cleared.";
      fi;csh="";
   ;;
   "T") clear;echo -e "${Green}Clear ${Yellow}${bold}thumbnail cache?${normal}(Y/y))";
       read -N 1 ctc;echo -e "\n";
       if [[ $ctc == Y ]] || [[ $ctc == y ]];
       then mv $HOME/.cache/magic-tape/jpg/* $HOME/.local/share/Trash/files/
       notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "Thumbnail cache cleared.";
       fi;ctc="";
   ;;
   "l") clear;like_video;
   ;;
   "L") clear;UNLIKE="$(tac $HOME/.cache/magic-tape/history/liked.txt|sed 's/^.*https:\/\/www\.youtube\.com/https:\/\/www\.youtube\.com/g'|cut -d' ' -f2-|eval "$PREF_SELECTOR""\"❌ Select video to unlike \"")";
      if [[ -z "$UNLIKE" ]]; then empty_query;
      else echo -e "${Red}${bold}Unlike video\n${Yellow}"$UNLIKE"?${normal}\n(Y/y))";
       read -N 1 uv;echo -e "\n";
       if [[ $uv == Y ]] || [[ $uv == y ]];
       then notification_img="$HOME/.cache/magic-tape/png/magic-tape.png";
        #UNLIKE="$(echo "$UNLIKE"|awk '{print $1}'|sed 's/^.*\///')";
        sed -i "/$UNLIKE/d" $HOME/.cache/magic-tape/history/liked.txt;
        notify-send -t $NOTIFICATION_DURATION -i "$notification_img" "❌ You have unliked $UNLIKE";
       fi;
      fi;uv="";
   ;;
   "q") clear;
   ;;
   *)echo -e "\n😕${Yellow}${bold}$db2${normal} ${Green}is an invalid key, please try again.${normal}\n"; sleep $TERMINAL_MESSAGE_DURATION;clear;
   ;;
  esac
 done
 db2="";
}
################# UBERZUGPP ###################
function exit_upp () {
 db2="q"
 PLAY=" "
 db="q"
 CHAN=" "
# killall fzf>/dev/null 2>&1
 ueberzugpp cmd -s "$SOCKET" -a exit >/dev/null 2>&1
# sleep 0.5
 #killall ueberzugpp>/dev/null 2>&1
 killall -9 -g magic-tape.sh>/dev/null 2>&1
}

clean_upp() {
 ueberzugpp cmd -s "$SOCKET" -a exit
 ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file /tmp/.magic_tape_upp
 UB_PID=$(cat /tmp/.magic_tape_upp)
 SOCKET=/tmp/ueberzugpp-"$UB_PID".socket
}

function draw_upp () {
 ueberzugpp cmd -s $SOCKET -i fzfpreview -a add -x "0" -y "0" --max-width $3 --max-height $4 -f $5
}
################# UBERZUG ######################
declare -r -x UEBERZUG_FIFO="$(mktemp --dry-run )"
function start_ueberzug {
    mkfifo "${UEBERZUG_FIFO}"
    <"${UEBERZUG_FIFO}" \
        ueberzug layer --parser bash --silent &
    # prevent EOF
    3>"${UEBERZUG_FIFO}" \
        exec
}

function finalise {
    3>&- \
        exec
    &>/dev/null \
        rm "${UEBERZUG_FIFO}"
    &>/dev/null \
        kill $(jobs -p)
}
######################################################
function clear_image (){
 if [[ "$IMAGE_SUPPORT" == "kitty" ]];then kitty icat --transfer-mode file  --clear;fi;
 if [[ "$IMAGE_SUPPORT" == "ueberzug" ]];then finalise;start_ueberzug;fi;
 if [[ "$IMAGE_SUPPORT" == "ueberzugpp" ]];then clean_upp;fi;
}

function draw_uber {
#sample draw_uber 35 35 90 3 /path/image.jpg
    >"${UEBERZUG_FIFO}" declare -A -p cmd=( \
        [action]=add [identifier]="preview" \
        [x]="$1" [y]="$2" \
        [width]="$3" [height]="$4" \
        [scaler]=fit_contain [scaling_position_x]=10 [scaling_position_y]=10 \
        [path]="$5")
}

function draw_preview {
 #sample draw_preview 90 3 35 35 /path/image.jpg
 if [[ "$IMAGE_SUPPORT" == "kitty" ]];then kitty icat  --transfer-mode file --place $3x$4@$1x$2 --scale-up   "$5";fi;
 if [[ "$IMAGE_SUPPORT" == "ueberzugpp" ]]; then yy="$(($FZF_PREVIEW_COLUMNS*3/7))"&&draw_upp $1 $2 "$(($3*5/3))" "$yy" $5;fi;
 if [[ "$IMAGE_SUPPORT" == "ueberzug" ]];then draw_uber $1 $2 $3 $4 $5;fi;
 if [[ "$IMAGE_SUPPORT" == "chafa" ]];then chafa --format=symbols -c full -s  $3 $5;fi;
}

function get_feed_json ()
{
 echo -e "${Green}Downloading${Yellow}${bold} $FEED...${normal}";
 echo -e "$db\n$ITEM\n$ITEM0\n$FEED\n$fzf_header">$HOME/.cache/magic-tape/history/last_action.txt;
 #if statement added to fix json problem. If the problem re-appears, uncomment the if statement, and comment  following line
 #if [ $db == "f" ]||[ $db == "t" ]||[ $db == "y" ];then LIST_LENGTH=$(($LIST_LENGTH * 2 ));else LIST_LENGTH="$(grep 'LIST_LENGTH:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";fi;
###LIST_LENGTH="$(grep 'LIST_LENGTH:' $HOME/.config/magic-tape/magic-tape.conf|sed 's/^#.*//g;s/^.*: //')";
 yt-dlp --cookies-from-browser $PREF_BROWSER --flat-playlist --extractor-args youtubetab:approximate_date --playlist-start $ITEM0 --playlist-end $(($ITEM0 + $(($LIST_LENGTH - 1)))) -j "https://www.youtube.com$FEED">$HOME/.cache/magic-tape/json/video_search.json;
 echo -e "${Green}Completed${Yellow}${bold} $FEED.${normal}";
 #correct back LIST_LENGTH value(fix json problem);
 #if [ $db == "f" ]||[ $db == "t" ];then LIST_LENGTH=$(($LIST_LENGTH / 2 ));fi;
}

function get_data ()
{
 #fix json problem first seen Apr 12 2023, where each item in the json file takes two lines, not one. While and until this stands, this one-liner corrects the issue. Also LIST_LENGTH=$(($LIST_LENGTH * 2 )) in get_feed_json function, exactly because of this issue
 #if [ $db == "f" ]||[ $db == "t" ];then even=2;while [ $even -le $(cat $HOME/.cache/magic-tape/json/video_search.json|wc -l) ];do echo "$(head -$even $HOME/.cache/magic-tape/json/video_search.json|tail +$even)">>$HOME/.cache/magic-tape/json/video_search_temp.json;even=$(($even +2));done;mv $HOME/.cache/magic-tape/json/video_search_temp.json $HOME/.cache/magic-tape/json/video_search.json;fi;

 jq '.id' $HOME/.cache/magic-tape/json/video_search.json|sed 's/\\"/⁆/g;s/"//g;s/⁆/"/g'>$HOME/.cache/magic-tape/search/video/ids.txt;
 jq '.title' $HOME/.cache/magic-tape/json/video_search.json|sed 's/\\"/⁆/g;s/"//g;s/⁆/"/g'>$HOME/.cache/magic-tape/search/video/titles.txt;
 jq '.duration_string' $HOME/.cache/magic-tape/json/video_search.json|sed 's/\\"/⁆/g;s/"//g;s/⁆/"/g'>$HOME/.cache/magic-tape/search/video/lengths.txt;
 jq '.url' $HOME/.cache/magic-tape/json/video_search.json|sed 's/\\"/⁆/g;s/"//g;s/⁆/"/g'>$HOME/.cache/magic-tape/search/video/urls.txt;
 jq '.timestamp' $HOME/.cache/magic-tape/json/video_search.json>$HOME/.cache/magic-tape/search/video/timestamps.txt;
 jq '.description' $HOME/.cache/magic-tape/json/video_search.json>$HOME/.cache/magic-tape/search/video/descriptions.txt;
 jq '.view_count' $HOME/.cache/magic-tape/json/video_search.json|sed 's/\\"/⁆/g;s/"//g;s/⁆/"/g'>$HOME/.cache/magic-tape/search/video/views.txt;
 jq '.channel_id' $HOME/.cache/magic-tape/json/video_search.json|sed 's/\\"/⁆/g;s/"//g;s/⁆/"/g'>$HOME/.cache/magic-tape/search/video/channel_ids.txt;
 jq '.channel' $HOME/.cache/magic-tape/json/video_search.json|sed 's/\\"/⁆/g;s/"//g;s/⁆/"/g'>$HOME/.cache/magic-tape/search/video/channel_names.txt;
 jq '.thumbnails[0].url' $HOME/.cache/magic-tape/json/video_search.json|sed 's/\\"/⁆/g;s/"//g;s/⁆/"/g'|sed 's/\.jpg.*$/\.jpg/g'>$HOME/.cache/magic-tape/search/video/image_urls.txt;
 jq '.live_status' $HOME/.cache/magic-tape/json/video_search.json>$HOME/.cache/magic-tape/search/video/live_status.txt;
 epoch="$(jq '.epoch' $HOME/.cache/magic-tape/json/video_search.json|head -1)";
 Y_epoch="$(date --date=@$epoch +%Y|sed 's/^0*//')";
 M_epoch="$(date --date=@$epoch +%m|sed 's/^0*//')";
 D_epoch="$(date --date=@$epoch +%j|sed 's/^0*//')";
 if [[ $db == "c" ]];
 then jq '.playlist_uploader' $HOME/.cache/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/.cache/magic-tape/search/video/channel_names.txt;
  jq '.playlist_uploader_id' $HOME/.cache/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/.cache/magic-tape/search/video/channel_ids.txt;
  fi;
 cat /dev/null>$HOME/.cache/magic-tape/search/video/thumbnails.txt;
 cat /dev/null>$HOME/.cache/magic-tape/search/video/shared.txt;
 i=1;
 while [ $i -le $(cat $HOME/.cache/magic-tape/search/video/titles.txt|wc -l) ];
 do img_path="$HOME/.cache/magic-tape/jpg/img-$(cat $HOME/.cache/magic-tape/search/video/ids.txt|head -$i|tail +$i).jpg";
  if [ ! -f  "$img_path" ];
  then echo "url = \"$(cat $HOME/.cache/magic-tape/search/video/image_urls.txt|head -$i|tail +$i)\"">>$HOME/.cache/magic-tape/search/video/thumbnails.txt;
   echo "output = \"$img_path\"">>$HOME/.cache/magic-tape/search/video/thumbnails.txt;
   cp $HOME/.cache/magic-tape/png/wait.png $HOME/.cache/magic-tape/jpg/img-$(cat $HOME/.cache/magic-tape/search/video/ids.txt|head -$i|tail +$i).jpg
  fi;
  ### parse approx date
  timestamp="$(cat $HOME/.cache/magic-tape/search/video/timestamps.txt|head -$i|tail +$i)";
  if [[ "$timestamp" != "null" ]];then Y_timestamp="$(date --date=@$timestamp +%Y|sed 's/^0*//')";
   M_timestamp="$(date --date=@$timestamp +%m|sed 's/^0*//')";
   D_timestamp="$(date --date=@$timestamp +%j|sed 's/^0*//')";
   if [ "$Y_epoch" -gt "$Y_timestamp" ];then approximate_date="$(($Y_epoch-$Y_timestamp)) years ago";fi;
   if [ "$Y_epoch" -eq $(($Y_timestamp + 1)) ];then approximate_date="One year ago";fi;
   if [ "$Y_epoch" -eq "$Y_timestamp" ]&&[ "$M_epoch" -gt "$M_timestamp" ];then approximate_date="$(($M_epoch-$M_timestamp)) months ago";fi;
   if [ "$Y_epoch" -eq "$Y_timestamp" ]&&[ "$M_epoch" -eq $(($M_timestamp + 1)) ];then approximate_date="One month ago";fi;
   if [ "$Y_epoch" -eq "$Y_timestamp" ]&&[ "$M_epoch" -eq "$M_timestamp" ]&&[ $D_epoch -eq $D_timestamp ] ;then approximate_date="Today";fi;
   #yesterday=$(($D_timestamp+1));
   if [ "$Y_epoch" -eq "$Y_timestamp" ]&&[ "$M_epoch" -eq "$M_timestamp" ]&&[ "$D_epoch" -gt "$D_timestamp" ] ;then approximate_date="$(($D_epoch - $D_timestamp)) days ago";fi;
   if [ "$Y_epoch" -eq "$Y_timestamp" ]&&[ "$M_epoch" -eq "$M_timestamp" ]&&[ "$D_epoch" -eq $(($D_timestamp + 1)) ] ;then approximate_date="Yesterday";fi;
  else approximate_date="$(head -$i $HOME/.cache/magic-tape/search/video/live_status.txt|tail +$i|sed 's/_/ /g;s/"//g')";
  fi;
  echo $approximate_date>>$HOME/.cache/magic-tape/search/video/shared.txt;
  ((i++));
 done;
 echo -e "${Green}Downloading thumbnails...${normal}";
 curl -s -K $HOME/.cache/magic-tape/search/video/thumbnails.txt& echo -e "${Green}Background thumbnails download.${normal}";
 if [ $ITEM -gt 1 ];then echo "Previous Page">>$HOME/.cache/magic-tape/search/video/titles.txt;fi;
 if [ $(cat $HOME/.cache/magic-tape/search/video/ids.txt|wc -l) -ge $LIST_LENGTH ];then echo "Next Page">>$HOME/.cache/magic-tape/search/video/titles.txt;fi;
 echo "Abort Selection">>$HOME/.cache/magic-tape/search/video/titles.txt;
}

function select_video ()
{
 PLAY="";
 PLAY=" $(cat -n $HOME/.cache/magic-tape/search/video/titles.txt|sed 's/^. *//g' |fzf\
 --info=hidden \
 --layout=reverse \
 --height=100% \
 --prompt="Select video: " \
 --header="$fzf_header" \
 --preview-window=left,50% \
 --tabstop=1 \
 --no-margin  \
 --bind=right:accept \
 --expect=shift-left,shift-right \
 +m \
 -i \
 --exact \
 --preview='
 height=$(($FZF_PREVIEW_COLUMNS /3 + 2));\
 if [[ "$IMAGE_SUPPORT" == "kitty" ]];then clear_image;fi;\
 i=$(echo {}|sed "s/\\t.*$//g");echo $i>$HOME/.cache/magic-tape/search/video/index.txt;\
 if [[ "$IMAGE_SUPPORT" != "none" ]]&&[[ "$IMAGE_SUPPORT" != "chafa" ]];then ll=0; while [ $ll -le $height ];do echo "";((ll++));done;fi;\
 TITLE="$(cat $HOME/.cache/magic-tape/search/video/titles.txt|head -$i|tail +$i)";\
 channel_name="$(cat $HOME/.cache/magic-tape/search/video/channel_names.txt|head -$i|tail +$i)";\
 channel_jpg="$(cat $HOME/.cache/magic-tape/search/video/channel_ids.txt|head -$i|tail +$i)"".jpg";\
 if [[ "$TITLE" == "Previous Page" ]];then draw_preview 1 1 $FZF_PREVIEW_COLUMNS $height $HOME/.cache/magic-tape/png/previous.png;\
 elif [[ "$TITLE" == "Next Page" ]];then draw_preview 1 1 $FZF_PREVIEW_COLUMNS $height $HOME/.cache/magic-tape/png/next.png;\
 elif [[ "$TITLE" == "Abort Selection" ]];then draw_preview 1 1 $FZF_PREVIEW_COLUMNS $height $HOME/.cache/magic-tape/png/abort.png;\
  else draw_preview 1 1 $FZF_PREVIEW_COLUMNS $height $HOME/.cache/magic-tape/jpg/img-"$(cat $HOME/.cache/magic-tape/search/video/ids.txt|head -$i|tail +$i)".jpg;\
  if [ -e $HOME/.cache/magic-tape/subscriptions/jpg/"$channel_jpg" ];\
   then if [[ "$IMAGE_SUPPORT" == "kitty" ]];then draw_preview $(($FZF_PREVIEW_COLUMNS - 4 )) $height 4 4 $HOME/.cache/magic-tape/subscriptions/jpg/"$channel_jpg";fi;\
   else if [[ "$IMAGE_SUPPORT" == "kitty" ]];then draw_preview $(($FZF_PREVIEW_COLUMNS - 4 )) $height 4 4 $HOME/.cache/magic-tape/png/magic-tape.png;fi;\
  fi;\
 fi;\
 ll=1; echo -ne "\x1b[38;5;241m"; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n -e "─";((ll++));done;echo -n -e "$normal";\
 echo -e "\n"$Yellow"$TITLE"$normal"" |fold -w $FZF_PREVIEW_COLUMNS -s ; \
 ll=1; echo -ne "\x1b[38;5;241m"; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n -e "─";((ll++));done;echo -n -e "$normal";\
 if [[ $TITLE != "Abort Selection" ]]&&[[ $TITLE != "Previous Page" ]]&&[[ $TITLE != "Next Page" ]];\
 then  LENGTH="$(cat $HOME/.cache/magic-tape/search/video/lengths.txt|head -$i|tail +$i)";\
  echo -e "\n"$Green"Length: "$Cyan"$LENGTH"$normal"";\
  SHARED="$(cat $HOME/.cache/magic-tape/search/video/shared.txt|head -$i|tail +$i)";\
  echo -e "$Green""Shared: "$Cyan"$SHARED"$normal""; \
  VIEWS="$(cat $HOME/.cache/magic-tape/search/video/views.txt|head -$i|tail +$i)";\
  echo -e "$Green""Views : ""$Cyan""$VIEWS";\
  if [[ $db != "c" ]];\
  then ll=1; echo -ne "\x1b[38;5;241m"; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n -e "─";((ll++));done;echo -n -e "$normal";\
   echo -e "\n"$Green"Channel: "$Yellow"$channel_name" |fold -w $FZF_PREVIEW_COLUMNS -s;\
  fi;\
  DESCRIPTION="$(cat $HOME/.cache/magic-tape/search/video/descriptions.txt|head -$i|tail +$i)";\
  if [[ $DESCRIPTION != "null" ]];
  then ll=1; echo -ne "\x1b[38;5;241m"; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n -e "─";((ll++));done;echo -n -e "$normal";\
   echo -e "\n\x1b[38;5;250m$DESCRIPTION"$normal""|fold -w $FZF_PREVIEW_COLUMNS -s; \
  fi;
 fi;')";
 clear_image;
 i=$(cat $HOME/.cache/magic-tape/search/video/index.txt);
  notification_img="$HOME/.cache/magic-tape/jpg/img-"$(cat $HOME/.cache/magic-tape/search/video/ids.txt|head -$i|tail +$i)".jpg";
 play_now="$(head -$i $HOME/.cache/magic-tape/search/video/urls.txt|tail +$i)";
 TITLE=$(head -$i $HOME/.cache/magic-tape/search/video/titles.txt|tail +$i);
 channel_name="$(cat $HOME/.cache/magic-tape/search/video/channel_names.txt|head -$i|tail +$i)";
 channel_id="$(cat $HOME/.cache/magic-tape/search/video/channel_ids.txt|head -$i|tail +$i)";
 if [ $ITEM  -ge $LIST_LENGTH ]&&[[ $PLAY == *"shift-left"* ]]; then TITLE="Previous Page";fi;
 if [ $ITEM  -le $LIST_LENGTH ]&&[[ $PLAY == *"shift-left"* ]]; then TITLE="Abort Selection";fi;
 if [[ $PLAY == *"shift-right"* ]]; then TITLE="Next Page";fi;
 if [[ $TITLE == "Next Page" ]];
 then ITEM=$(($ITEM + $LIST_LENGTH));
  #change implemented when the 2-lines-per-item-in-the-json-file issue appeared
  #if [[ $db == "f" ]]||[[ $db == "t" ]]; then ITEM0=$(($ITEM0 + $LIST_LENGTH * 2));else ITEM0=$ITEM;fi;
  ITEM0=$ITEM;
 fi;
 if [[ $TITLE == "Previous Page" ]];
 then ITEM=$(($ITEM - $LIST_LENGTH));
  #change implemented when the 2-lines-per-item-in-the-json-file issue appeared
  #if [[ $db == "f" ]]||[[ $db == "t" ]]; then ITEM0=$(($ITEM0 - $LIST_LENGTH * 2));else ITEM0=$ITEM;fi;
  ITEM0=$ITEM;
 fi;
 if [[ $TITLE == "Abort Selection" ]];then big_loop=0;fi;
 if [[ $PLAY == " " ]]; then echo "ABORT!"; TITLE="Abort Selection";big_loop=0;clear;fi;
 PLAY="";
}

function download_video ()
{
 cd "$HOME""$DOWNLOAD_DIRECTORY";
 echo -e "${Green}Directory: ""$HOME"${Yellow}${bold}"$DOWNLOAD_DIRECTORY";
 echo -e "${Green}Downloading${Yellow}${bold} $play_now${normal}...]";
 notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/download.png "Video Downloading: $TITLE";
 yt-dlp "$play_now";
 notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "Video Downloading of $TITLE is now complete.";
 echo -e "${Green}Video Downloading of${Yellow}${bold} $TITLE ${Green}is now complete.${normal}";
 sleep $TERMINAL_MESSAGE_DURATION;
 cd ;
 clear;
}

function download_audio ()
{
 cd "$HOME""$DOWNLOAD_DIRECTORY";
 echo -e "${Green}Directory: ""$HOME"${Yellow}${bold}"$DOWNLOAD_DIRECTORY";
 echo -e "${Green}Downloading audio  of${Yellow}${bold} $play_now...${normal}";
 notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/download.png "Audio Downloading: $TITLE";
 yt-dlp --extract-audio --audio-quality 0 --embed-thumbnail "$play_now";
 notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "Audio Downloading of $TITLE is now complete.";
 echo -e "${Green}Audio Downloading of${Yellow}${bold} $TITLE ${Green}is now complete.${normal}";
 sleep $TERMINAL_MESSAGE_DURATION;
 cd ;
 clear;
}

function message_audio_video ()
{
 echo -e "${Green}${bold}Playing:${Yellow} $play_now\n${Green}Title  :${Yellow} $TITLE\n${Green}Channel:${Yellow} $channel_name${normal}";
 if [[ -n "$play_now" ]] && [[ -n "$TITLE" ]] && [[ -z "$(tail -1 $HOME/.cache/magic-tape/history/watch_history.txt|grep "$play_now" )" ]];
 then echo "$channel_id"" ""$channel_name"" ""$play_now"" ""$TITLE">>$HOME/.cache/magic-tape/history/watch_history.txt;
 #echo "{\"url\": \"$play_now\", \"title\": \"$TITLE\", \"channel\": \"$channel_name\", \"channel_id\": \"$channel_id\"}">>$HOME/.cache/magic-tape/history/watch_history.json;
 fi;
 notify-send -t $NOTIFICATION_DURATION -i "$notification_img" "Playing: $TITLE";
 }

function select_action ()
{
 clear;
 ACTION="$(echo -e "Play ⭐ Video 360p\nPlay ⭐ ⭐ Video 720p\nPlay ⭐ ⭐ ⭐ Best Video/Live\nPlay ⭐ ⭐ ⭐ Best Audio\nDownload Video 🔽\nDownload Audio 🔽\nLike Video ❤️\nBrowse Feed of channel "$channel_name" 📺\nSubscribe to channel "$channel_name" 📋\nOpen in browser 🌐\nCopy link 🔗\nQuit ❌"|eval "$PREF_SELECTOR""\"Select action \"")";
 case $ACTION in
  "Play ⭐ Video 360p") message_audio_video;if [[ "$SHOW_MPV_KEYBINDINGS" == 'yes' ]];then print_mpv_video_shortcuts;fi;mpv --ytdl-raw-options=format=18 "$play_now";play_now="";TITLE="";
  ;;
  "Play ⭐ ⭐ Video 720p") message_audio_video;if [[ "$SHOW_MPV_KEYBINDINGS" == 'yes' ]];then print_mpv_video_shortcuts;fi;mpv --ytdl-raw-options=format=22 "$play_now";play_now="";TITLE="";
  ;;
  "Play ⭐ ⭐ ⭐ Best Video/Live") message_audio_video;if [[ "$SHOW_MPV_KEYBINDINGS" == 'yes' ]];then print_mpv_video_shortcuts;fi;mpv "$play_now";play_now="";TITLE="";
  ;;
  "Play ⭐ ⭐ ⭐ Best Audio") message_audio_video;if [[ "$SHOW_MPV_KEYBINDINGS" == 'yes' ]];then print_mpv_audio_shortcuts;fi;mpv --ytdl-raw-options=format=ba "$play_now";play_now="";TITLE="";
  ;;
  "Download Video 🔽") clear;download_video;echo -e "\n${Green}Video Download complete.\n${normal}";
  ;;
  "Download Audio 🔽") clear;download_audio;echo -e "\n${Green}Audio Download complete.${normal}\n";
  ;;
  "Like Video ❤️") clear;
   if [[ -z "$(grep "$play_now" $HOME/.cache/magic-tape/history/liked.txt)" ]];
   then echo "$channel_id"" ""$channel_name"" ""$play_now"" ""$TITLE">>$HOME/.cache/magic-tape/history/liked.txt;
   notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "❤️ Video added to Liked Videos.";
   else notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "❤️ Video already added to Liked Videos.";
   fi;
  ;;
  "Browse Feed of channel"*) clear;db="c"; P="$channel_id";
   channel_feed;
  ;;
  "Subscribe to channel"*) clear;
   if [ -n "$(grep $channel_id $HOME/.cache/magic-tape/subscriptions/subscriptions.txt)" ];
   then notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/subscriptions/jpg/$channel_id".jpg" "You are already subscribed to $channel_name ";
   else C=${channel_name// /+};C=${C//\'/%27};
    if [[ "$C" == "null" ]]; then notify-send -t $NOTIFICATION_DURATION "❌ You cannot subscribe to this channel (null)";
    else echo -e "${Green}Downloading data of ${Yellow}${bold}$channel_name${normal}${Green} channel...${normal}";
     yt-dlp --cookies-from-browser $PREF_BROWSER --flat-playlist --playlist-start 1 --playlist-end 10 -j "https://www.youtube.com/results?search_query="$C"&sp=EgIQAg%253D%253D"|grep "$channel_id">$HOME/.cache/magic-tape/json/channel_search.json;
     channel_thumbnail_url="$(jq '.thumbnails[1].url' $HOME/.cache/magic-tape/json/channel_search.json|sed 's/"//g')";
     echo -e "${Green}Dowloading thumbnail of${Yellow}${bold} $channel_name${normal}${Green} channel...${normal}";
     curl -s -o $HOME/.cache/magic-tape/subscriptions/jpg/$channel_id".jpg" "https:""$channel_thumbnail_url";
     echo -e "${Green}Done.${normal}";
     echo "$channel_id"" ""$channel_name">>$HOME/.cache/magic-tape/subscriptions/subscriptions.txt;
     notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/subscriptions/jpg/$channel_id".jpg" "You have subscribed to $channel_name ";
     echo -e "${Red}${bold}NOTICE: ${Yellow}${bold}In order for this action to take effect in YouTube, you need to subscribe manually from a browser as well.\nDo you want to do it now? (Y/y)${normal}"|fold -w 75 -s;
     read -N 1 sas;echo -e "\n";
     if [[ $sas == Y ]] || [[ $sas == y ]];then $LINK_BROWSER "https://www.youtube.com/channel/"$channel_id&echo "Opened $PREF_BROWSER";fi;
    fi;
   fi;
  ;;
  "Open in browser 🌐")clear;notify-send -t $NOTIFICATION_DURATION "🌐 Opening video in browser..."& $LINK_BROWSER "$play_now";
  ;;
  "Copy link 🔗")clear;notify-send -t $NOTIFICATION_DURATION "🔗 Link copied to clipboard."& echo "$play_now"|xclip -sel clip;
  ;;
  "Quit ❌") clear;
  ;;
  *)echo -e "\n😕${Yellow}${bold}$db${normal} ${Green}is an invalid key, please try again.${normal}\n"; sleep $TERMINAL_MESSAGE_DURATION;clear;
  ;;
 esac
 ACTION="";
}

function empty_query ()
{
 clear;
 echo "😕 Selection cancelled...";
 sleep $TERMINAL_MESSAGE_DURATION;
}
###############################################################################
export -f draw_preview draw_uber clear_image start_ueberzug finalise clean_upp draw_upp
load_config
export IMAGE_SUPPORT UEBERZUG_FIFO SOCKET Green GreenInvert Yellow Red Magenta Cyan bold normal $FZF_PREVIEW_COLUMNS $FZF_PREVIEW_LINES
#trap exit_upp HUP INT QUIT TERM EXIT ERR ABRT
db=""
load_config
if [[ $IMAGE_SUPPORT == "ueberzugpp" ]];then trap exit_upp  HUP INT QUIT TERM EXIT ERR ABRT ;clean_upp; fi
clear_image
while [ "$db" != "q" ]
do db="$(echo -e "${Yellow}${bold}┏┳┓┏━┓┏━╸╻┏━╸   ╺┳╸┏━┓┏━┓┏━╸${normal}\n${Yellow}${bold}┃┃┃┣━┫┃╺┓┃┃  ╺━╸ ┃ ┣━┫┣━┛┣╸ ${normal}\n${Yellow}${bold}╹ ╹╹ ╹┗━┛╹┗━╸    ╹ ╹ ╹╹  ┗━╸${normal} \n ${Yellow}${bold}f ${normal}${Red}to browse Subscriptions Feed.${normal}          \n ${Yellow}${bold}y ${normal}${Red}to browse YT algorithm Feed. ${normal}          \n ${Yellow}${bold}t ${Red}to browse Trending Feed.${normal}               \n ${Yellow}${bold}s${normal} ${Green}to Search for a key word/phrase.${normal}       \n ${Yellow}${bold}r ${Green}to Repeat previous action.${normal}             \n ${Yellow}${bold}c ${Green}to select a Channel Feed.${normal}              \n ${Yellow}${bold}l ${Magenta}to browse your Liked Videos.${normal}           \n ${Yellow}${bold}h ${Magenta}to browse your Watch History${normal}.          \n ${Yellow}${bold}j ${Magenta}to browse your Search History.${normal}         \n ${Yellow}${bold}m ${Cyan}for Miscellaneous Menu.${normal}                \n ${Yellow}${bold}q ${Cyan}to Quit${normal}."|fzf \
--preview-window=0 \
--disabled \
--color='gutter:-1' \
--reverse \
--ansi \
--tiebreak=begin \
--border=rounded \
+i \
+m \
--nth=1 \
--info=hidden \
--header-lines=3 \
--prompt="Enter:" \
--header-first \
--expect=A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,1,2,3,4,5,6,7,8,9,0 )"
db="$(echo $db|awk '{print $1}')"
 case $db in
  "f") clear;
     big_loop=1;
     ITEM=1;
     ITEM0=1;
     FEED="/feed/subscriptions";
     while [ $big_loop -eq 1 ];
     do fzf_header="$(echo ${FEED^^}|sed 's/[\/\?=]/ /g') videos $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
      get_feed_json;
      get_data;
      small_loop=1;
      while [ $small_loop -eq 1 ];
      do select_video ;
       if [[ "$TITLE" == "Next Page" ]]||[[ "$TITLE" == "Previous Page" ]];then small_loop=0;fi;
       if [[ "$TITLE" == "Abort Selection" ]];then small_loop=0;big_loop=0;fi;
       if [[ "$TITLE" != "Abort Selection" ]]&&[[ "$TITLE" != "Next Page" ]]&&[[ "$TITLE" != "Previous Page" ]];then select_action;fi;
      done;
     done;
     clear;
  ;;
  "y") clear;
     big_loop=1;
     ITEM=1;
     ITEM0=1;
     FEED="";
     while [ $big_loop -eq 1 ];
     do fzf_header="YT algorithm suggestions, videos $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
      get_feed_json;
      get_data;
      small_loop=1;
      while [ $small_loop -eq 1 ];
      do select_video ;
       if [[ "$TITLE" == "Next Page" ]]||[[ "$TITLE" == "Previous Page" ]];then small_loop=0;fi;
       if [[ "$TITLE" == "Abort Selection" ]];then small_loop=0;big_loop=0;fi;
       if [[ "$TITLE" != "Abort Selection" ]]&&[[ "$TITLE" != "Next Page" ]]&&[[ "$TITLE" != "Previous Page" ]];then select_action;fi;
      done;
     done;
     clear;
  ;;
  "t") clear;
     big_loop=1;
     ITEM=1;
     ITEM0=1;
     FEED="/feed/trending";
     while [ $big_loop -eq 1 ];
     do fzf_header="$(echo ${FEED^^}|sed 's/[\/\?=]/ /g') videos $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
      get_feed_json;
      get_data;
      small_loop=1;
      while [ $small_loop -eq 1 ];
      do select_video ;
       if [[ "$TITLE" == "Next Page" ]]||[[ "$TITLE" == "Previous Page" ]];then small_loop=0;fi;
       if [[ "$TITLE" == "Abort Selection" ]];then small_loop=0;big_loop=0;fi;
       if [[ "$TITLE" != "Abort Selection" ]]&&[[ "$TITLE" != "Next Page" ]]&&[[ "$TITLE" != "Previous Page" ]];then select_action;fi;
      done;
     done;
     clear;
  ;;
  "s") clear;
     echo -e "🔎 Enter keyword/keyphrase to search for: \n\n";
     read  P;
     if [[ -z "$P" ]];
      then empty_query;
     else P=${P// /+};
      echo "$P">>$HOME/.cache/magic-tape/history/search_history.txt;
      search_filter;
      big_loop=1;
      ITEM=1;
      ITEM0=1;
      FEED="/results?search_query=""$P""$FILTER";
      while [ $big_loop -eq 1 ];
      do fzf_header="$(echo "$FILT_PROMPT"|sed 's/ .*/ /')""$(echo ${FEED^^}|sed 's/&SP=.*$//;s/^.*SEARCH_QUERY=/search: /;s/[\/\?=&+]/ /g') videos: $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
       get_feed_json;
       get_data;
       small_loop=1;
       while [ $small_loop -eq 1 ];
       do select_video ;
        if [[ "$TITLE" == "Next Page" ]]||[[ "$TITLE" == "Previous Page" ]];then small_loop=0;fi;
        if [[ "$TITLE" == "Abort Selection" ]];then small_loop=0;big_loop=0;fi;
        if [[ "$TITLE" != "Abort Selection" ]]&&[[ "$TITLE" != "Next Page" ]]&&[[ "$TITLE" != "Previous Page" ]];then select_action;fi;
       done;
      done;
     fi;
     clear;
  ;;
  "r") clear;
     db="$(head -1 $HOME/.cache/magic-tape/history/last_action.txt)";
     ITEM="$(head -2 $HOME/.cache/magic-tape/history/last_action.txt|tail +2)";
     ITEM0="$(head -3 $HOME/.cache/magic-tape/history/last_action.txt|tail +3)";
     FEED="$(head -4 $HOME/.cache/magic-tape/history/last_action.txt|tail +4)";
     fzf_header="$(head -5 $HOME/.cache/magic-tape/history/last_action.txt|tail +5)";
     big_loop=1;
     first=1;
     while [ $big_loop -eq 1 ];
     do if [ $first -eq 0 ];then fzf_header="$(echo ${FEED^^}|sed 's/&SP=.*$//;s/^.*SEARCH_QUERY=/search: /;s/[\/\?=]/ /g') videos $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";get_feed_json;get_data;fi;
        small_loop=1;
        while [ $small_loop -eq 1 ];
        do select_video ;
         first=0;
         if [[ "$TITLE" == "Next Page" ]]||[[ "$TITLE" == "Previous Page" ]];then small_loop=0;fi;
         if [[ "$TITLE" == "Abort Selection" ]];then small_loop=0;big_loop=0;fi;
         if [[ "$TITLE" != "Abort Selection" ]]&&[[ "$TITLE" != "Next Page" ]]&&[[ "$TITLE" != "Previous Page" ]];then select_action;fi;
        done;
        first=0;
     done;
     clear;
  ;;
  "c") clear;
     channel_name="$(cat $HOME/.cache/magic-tape/subscriptions/subscriptions.txt|cut -d' ' -f2-|eval "$PREF_SELECTOR""\"🔎 Select channel \"")";
     echo -e "${Green}Selected channel:${Yellow}${bold} $channel_name"${normal};
     if [[ -z "$channel_name" ]];
     then empty_query;
     else P="$(grep "$channel_name" $HOME/.cache/magic-tape/subscriptions/subscriptions.txt|head -1|awk '{print $1}')";
     channel_feed;
     fi;
  ;;
  "h") clear;
     TITLE="$(echo -e "ABORT SELECTION\n""$(tac $HOME/.cache/magic-tape/history/watch_history.txt|sed 's/^.*https:\/\/www\.youtube\.com/https:\/\/www\.youtube\.com/g'|cut -d' ' -f2-)"|eval "$PREF_SELECTOR""\"🔎 Select previous video \"")";
     if [[ "$TITLE" == "ABORT SELECTION" ]]||[[ -z "$TITLE" ]];
      then empty_query;
     else  TITLE=${TITLE//\*/\\*};
      channel_id="$(grep "$TITLE" $HOME/.cache/magic-tape/history/watch_history.txt|head -1|awk '{print $1}')";
      channel_name="$(grep "$TITLE" $HOME/.cache/magic-tape/history/watch_history.txt|head -1|sed 's/https:\/\/www\.youtube\.com.*$//'|cut -d' ' -f2-)";
      play_now="$(grep "$TITLE" $HOME/.cache/magic-tape/history/watch_history.txt|head -1|sed 's/^.*https:\/\/www\.youtube\.com/https:\/\/www\.youtube\.com/g'|awk '{print $1}')";
      notification_img="$HOME/.cache/magic-tape/jpg/img-"${play_now##*=}".jpg";
      select_action;
     fi;
     clear;
  ;;
  "j") clear;
     P="$(echo -e "ABORT SELECTION\n""$(tac $HOME/.cache/magic-tape/history/search_history.txt|sed 's/+/ /g;s/\//')"|eval "$PREF_SELECTOR""\"🔎 Select key word/phrase \"")";
     if [[ "$P" == "ABORT SELECTION"  ]]||[[ -z "$P" ]];
     then empty_query;
     else P=${P// /+};
      big_loop=1;
      ITEM=1;
      ITEM0=$ITEM;
      search_filter;
      FEED="/results?search_query=""$P""$FILTER";
      while [ $big_loop -eq 1 ];
      do fzf_header="$(echo "$FILT_PROMPT"|sed 's/ .*/ /')""$(echo ${FEED^^}|sed 's/&SP=.*$//;s/^.*SEARCH_QUERY=/search: /;s/[\/\?=&+]/ /g') videos: $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
       get_feed_json;
       get_data;
       small_loop=1;
       while [ $small_loop -eq 1 ];
       do select_video ;
        if [[ "$TITLE" == "Next Page" ]]||[[ "$TITLE" == "Previous Page" ]];then small_loop=0;fi;
        if [[ "$TITLE" == "Abort Selection" ]];then small_loop=0;big_loop=0;fi;
        if [[ "$TITLE" != "Abort Selection" ]]&&[[ "$TITLE" != "Next Page" ]]&&[[ "$TITLE" != "Previous Page" ]];then select_action;fi;
       done;
      done;
      fi;
     clear;
  ;;
  "l") clear;
     TITLE="$(echo -e "ABORT SELECTION\n""$(tac $HOME/.cache/magic-tape/history/liked.txt|sed 's/^.*https:\/\/www\.youtube\.com/https:\/\/www\.youtube\.com/g'|cut -d' ' -f2-)"|eval "$PREF_SELECTOR""\"❤️ Select liked video \"")";
     if [[ "$TITLE" == "ABORT SELECTION" ]]||[[ -z "$TITLE" ]];
     then empty_query;
     else TITLE=${TITLE//\*/\\*};
     channel_id="$(grep "$TITLE" $HOME/.cache/magic-tape/history/liked.txt|head -1|awk '{print $1}')";
     channel_name="$(grep "$TITLE" $HOME/.cache/magic-tape/history/liked.txt|head -1|sed 's/https:\/\/www\.youtube\.com.*$//'|cut -d' ' -f2-)";
     play_now="$(grep "$TITLE" $HOME/.cache/magic-tape/history/liked.txt|head -1|sed 's/^.*https:\/\/www\.youtube\.com/https:\/\/www\.youtube\.com/g'|awk '{print $1}')";
      notification_img="$HOME/.cache/magic-tape/jpg/img-"${play_now##*=}".jpg";
      select_action;
     fi;
     clear;
  ;;
  "m") clear;misc_menu;
  ;;
  "q") notify-send -t $NOTIFICATION_DURATION -i $HOME/.cache/magic-tape/png/magic-tape.png "Exited magic-tape";
  ;;
  *)clear;echo -e "\n${Yellow}${bold}$db${normal} is an invalid key, please try again.\n";sleep $TERMINAL_MESSAGE_DURATION;
  ;;
 esac
done
