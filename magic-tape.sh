#! /bin/bash
#┏┳┓┏━┓┏━╸╻┏━╸   ╺┳╸┏━┓┏━┓┏━╸
#┃┃┃┣━┫┃╺┓┃┃  ╺━╸ ┃ ┣━┫┣━┛┣╸
#╹ ╹╹ ╹┗━┛╹┗━╸    ╹ ╹ ╹╹  ┗━╸
#A script written by Christos Angelopoulos in March 2023 under GNU GENERAL PUBLIC LICENSE
#

function color_set()
{
	if [[ "$COLOR" == "No" ]];
	then Yellow="";
		Green="";
		Red="";
		Magenta="";
		Cyan="";
		bold=`tput bold`
		normal=`tput sgr0`
	else Yellow="\033[1;33m"
		Green="\033[1;32m"
		Red="\033[1;31m"
		Magenta="\033[1;35m"
		Cyan="\033[1;36m"
		bold=`tput bold`
		normal=`tput sgr0`
	fi;
}
function setup ()
{
	clear;kitty +kitten icat --clear;
	PREF_BROWSER="$(echo -e "brave\nchrome\nchromium\nedge\nfirefox\nopera\nvivaldi"|rofi -dmenu -i -p "SET UP: 🌍 Select browser to login YouTube with" -l 20 -width 40)";
	if [[ "$PREF_BROWSER" == "" ]];then empty_query;
	else if [[ $PREF_BROWSER == "brave" ]];then BROWSER=brave-browser-stable;else BROWSER=$PREF_BROWSER;fi;
	LIST_LENGTH="$(echo -e "10\n15\n20\n25\n30\n35\n40\n45\n50\n55\n60\n65\n70"|rofi -dmenu -i -p "SET UP: 📋 Select video list length" -l 20 -width 40)";
	if [[ "$LIST_LENGTH" == "" ]];then empty_query;
		else	DIALOG_DELAY="$(echo -e "0\n0.5\n1\n1.5\n2\n2.5\n3\n3.5\n4"|rofi -dmenu -i -p "SET UP: 🕓 Select dialog message duration(sec)" -l 20 -width 40)";
			if [[ "$DIALOG_DELAY" == "" ]];
			then empty_query;
			else NOTIF_DELAY="$(echo -e "0\n1\n2\n3\n4\n5\n6"|rofi -dmenu -i -p "SET UP: 🕓 Select notification message duration(sec)" -l 20 -width 40)";
				if [[ "$NOTIF_DELAY" == "" ]];
				then empty_query;
				else NOTIF_DELAY=$(($NOTIF_DELAY * 1000));
				COLOR="$(echo -e "Yes\nNo"|rofi -dmenu -i -p "SET UP: 🕓 Do  you prefer multi-colored terminal output?" -l 20 -width 40)";
				if [[ "$COLOR" == "" ]];
				then empty_query;
				else echo -e "$PREF_BROWSER\n$BROWSER\n$LIST_LENGTH\n$DIALOG_DELAY\n$NOTIF_DELAY\n$COLOR">$HOME/git/magic-tape/config.txt;
					notify-send -t 5000 "SET UP: 😀 Your preferences are now stored!";
					echo -e "${Yellow}${bold}SET UP: 😀 Your preferences are now stored!${normal}";	sleep 2;
					fi;
				fi;
			fi;
		fi;
	fi;
	color_set;
	picposy=1;
	clear;
}

function like_video ()
{
	LIKE="$(tac $HOME/git/magic-tape/history/watch_history.txt|cut -d' ' -f2-|rofi -dmenu -i -p "❤️ Select video to like" -l 20 -width 40)";
	if [[ -z "$LIKE" ]];
		then empty_query;
	else echo -e "❤️ Add\n${Yellow}${bold}"$LIKE"${normal}\nto Liked Videos?(Y/y))";
		read -N 1 alv;echo -e "\n";
		if [[ $alv == Y ]] || [[ $alv == y ]];
		then if [[ -z "$(grep "$LIKE" $HOME/git/magic-tape/history/liked.txt)" ]];
			then echo "$(grep "$LIKE" $HOME/git/magic-tape/history/watch_history.txt|head -1)" >>	$HOME/git/magic-tape/history/liked.txt;
				notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "❤️ Video added to Liked Videos.";
			else notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "❤️ Video already added to Liked Videos.";
			fi;
		fi;alv="";
	fi;
}

function import_subscriptions()
{
	echo -e "Your magic-tape subscriptions will be synced with your YouTube ones.Before initializing this function, make sure you are logged in in your YT account, and you have set up your prefered browser.\nProceed? (Y/y)"|fold -w 75 -s;
	read -N 1 impsub ;echo -e "\n";
	if [[ $impsub == "Y" ]] || [[ $impsub == "y" ]];
	then 	echo -e "${Yellow}${bold}[Downloading subscriptions data...]${normal}";
		new_subs=subscriptions_$(date +%F).json;
		yt-dlp --cookies-from-browser $PREF_BROWSER --flat-playlist -j "https://www.youtube.com/feed/channels">$HOME/git/magic-tape/json/$new_subs;
		echo -e "${Yellow}${bold}[Download Complete.]${normal}";
		jq '.id' $HOME/git/magic-tape/json/$new_subs|sed 's/"//g'>$HOME/git/magic-tape/search/channels/channel_ids.txt;
		jq '.title' $HOME/git/magic-tape/json/$new_subs|sed 's/"//g'>$HOME/git/magic-tape/search/channels/channel_names.txt;
		jq '.thumbnails[1].url' $HOME/git/magic-tape/json/$new_subs|sed 's/"//g'>$HOME/git/magic-tape/search/channels/image_urls.txt;

		cat /dev/null>$HOME/git/magic-tape/search/channels/thumbnails.txt;
		cp $HOME/git/magic-tape/subscriptions/subscriptions.txt $HOME/git/magic-tape/subscriptions/subscriptions-$(date +%F).bak.txt;
		cat /dev/null>$HOME/git/magic-tape/subscriptions/subscriptions.txt;
		i=1;
		while [ $i -le $(cat $HOME/git/magic-tape/search/channels/channel_ids.txt|wc -l) ];
		do	echo "$(cat $HOME/git/magic-tape/search/channels/channel_ids.txt|head -$i|tail +$i) $(cat $HOME/git/magic-tape/search/channels/channel_names.txt|head -$i|tail +$i)">>$HOME/git/magic-tape/subscriptions/subscriptions.txt;
			img_path="$HOME/git/magic-tape/subscriptions/jpg/$(cat $HOME/git/magic-tape/search/channels/channel_ids.txt|head -$i|tail +$i).jpg";
			if [ ! -f  "$img_path" ];
			then echo "url = \"https:$(cat $HOME/git/magic-tape/search/channels/image_urls.txt|head -$i|tail +$i)\"">>$HOME/git/magic-tape/search/channels/thumbnails.txt;
				echo "output = \"$img_path\"">>$HOME/git/magic-tape/search/channels/thumbnails.txt;
			fi;
			((i++));
		done;
		echo -e "${Yellow}${bold}[Downloading thumbnails...]${normal}";
		curl -s -K $HOME/git/magic-tape/search/channels/thumbnails.txt;
		echo -e "${Yellow}${bold}[Thumbnail download complete.]${normal}";
		echo -e "Your magic-tape subscriptions are now updated.\nA backup copy of your old subscriptions is kept in\n${Yellow}${bold}$HOME/git/magic-tape/subscriptions/subscriptions-$(date +%F).bak.txt${normal}\nPress any key to return to the miscellaneous menu: ";
		read -N 1  imp2;clear;mv $HOME/git/magic-tape/json/$new_subs $HOME/.local/share/Trash/files/;
	fi;
}

function print_mpv_video_shortcuts()
{
echo -e "╭───────────────────────────╮";
echo -e "│    ${Yellow}${bold}MPV VIDEO SHORTCUTS${normal}    │";
echo -e "├───────────┬───────────────┤";
echo -e "│ ${Cyan}${bold}  SPACE${normal}   │  ${Cyan}${bold}Pause/Play${normal}   │";
echo -e "├───────────┼───────────────┤";
echo -e "│   ${Green}${bold}9  0${normal}    │  ${Green}${bold}-/+ Volume${normal}   │";
echo -e "├───────────┼───────────────┤";
echo -e "│     ${Green}${bold}m${normal}     │     ${Green}${bold}Mute${normal}      │";
echo -e "├───────────┼───────────────┤";
echo -e "│     ${Cyan}${bold}f${normal}     │  ${Cyan}${bold}Full Screen${normal}  │";
echo -e "├───────────┼───────────────┤";
echo -e "│   ${Magenta}${bold}←   →${normal}   │  ${Magenta}${bold}-/+  5 sec${normal}   │";
echo -e "├───────────┼───────────────┤";
echo -e "│   ${Magenta}${bold}↑   ↓${normal}   │  ${Magenta}${bold}-/+  1 min${normal}   │";
echo -e "├───────────┼───────────────┤";
echo -e "│    ${Cyan}${bold} q  ${normal}   │     ${Cyan}${bold}Quit${normal}      │";
echo -e "╰───────────┴───────────────╯"
}

function print_mpv_audio_shortcuts()
{
echo -e "╭───────────────────────────╮";
echo -e "│    ${Yellow}${bold}MPV AUDIO SHORTCUTS${normal}    │";
echo -e "├───────────┬───────────────┤";
echo -e "│ ${Cyan}${bold}  SPACE${normal}   │  ${Cyan}${bold}Pause/Play${normal}   │";
echo -e "├───────────┼───────────────┤";
echo -e "│   ${Green}${bold}9  0${normal}    │  ${Green}${bold}-/+ Volume${normal}   │";
echo -e "├───────────┼───────────────┤";
echo -e "│     ${Green}${bold}m${normal}     │     ${Green}${bold}Mute${normal}      │";
echo -e "├───────────┼───────────────┤";
echo -e "│   ${Magenta}${bold}←   →${normal}   │  ${Magenta}${bold}-/+  5 sec${normal}   │";
echo -e "├───────────┼───────────────┤";
echo -e "│   ${Magenta}${bold}↑   ↓${normal}   │  ${Magenta}${bold}-/+  1 min${normal}   │";
echo -e "├───────────┼───────────────┤";
echo -e "│    ${Cyan}${bold} q  ${normal}   │     ${Cyan}${bold}Quit${normal}      │";
echo -e "╰───────────┴───────────────╯"
}



function misc_menu ()
{
	clear;	kitty icat --transfer-mode file  --clear;
	while [ "$db2" != "q" ] ;
	do	echo "╭────────────────────────────────────────╮";
		echo -e "│${Yellow}${bold}Miscellaneous menu${normal}                Enter:│";
		echo "├────────────────────────────────────────┤";
		echo -e "│ ${Yellow}${bold}P ${Cyan}to SET UP PREFENCES!${normal}                 │";
		echo "├────────────────────────────────────────┤";
		echo -e "│ ${Yellow}${bold}l ${Red}to LIKE a video.${normal}                     │";
		echo -e "│ ${Yellow}${bold}L ${Red}to UNLIKE a video.${normal}                   │";
		echo "├────────────────────────────────────────┤";
		echo -e "│ ${Yellow}${bold}I ${Green}to import subscriptions from YouTube.${normal}│";
		echo -e "│ ${Yellow}${bold}n ${Green}to subscribe to a new channel.${normal}       │";
		echo -e "│ ${Yellow}${bold}u ${Green}to unsubscribe from a channel.${normal}       │";
		echo "├────────────────────────────────────────┤";
		echo -e "│ ${Yellow}${bold}H ${Magenta}to clear ${Yellow}watch${Magenta} history.${normal}              │";
		echo -e "│ ${Yellow}${bold}S ${Magenta}to clear ${Yellow}search${Magenta} history.${normal}             │";
		echo -e "│ ${Yellow}${bold}T ${Magenta}to clear ${Yellow}thumbnail${Magenta} cache.${normal}            │";
		echo "├────────────────────────────────────────┤";
		echo -e "│ ${Yellow}${bold}q${normal} ${Cyan}to quit this menu.${normal}                   │";
		echo  "╰────────────────────────────────────────╯";
		echo -en "Select: ";read -N 1  db2;
		case $db2 in
  	P) setup;
  	;;
			I) clear;
						import_subscriptions;
						picposy=1;
			;;
			n) clear;
						kitty +kitten icat --clear;
						kitty +kitten icat  --place 6x6@0x0 $HOME/git/magic-tape/png/search.png;
						echo -e "\tEnter keyword/keyphrase\n\tfor a channel\n\tto search for: \n";
						read  C;
						kitty +kitten icat --clear;
						if [[ -z "$C" ]];
						then empty_query;
						else C=${C// /+};C=${C//\'/%27};
     		repeat_channel_search=1;
							ITEM=1;
							FEED="/results?search_query="$C"&sp=EgIQAg%253D%253D";
							while [ $repeat_channel_search -eq 1 ];
     		do fzf_header="$(echo ${FEED^^}|sed 's/&SP=.*$//;s/^.*SEARCH_QUERY=/search: /;s/[\/\?=&+]/ /g') channels: $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
							echo -e "${Yellow}${bold}[Downloading $FEED...]${normal}";
							echo -e "$db\n$ITEM\n$FEED\n$fzf_header">$HOME/git/magic-tape/history/last_action.txt;
							yt-dlp --cookies-from-browser $PREF_BROWSER --flat-playlist --playlist-start $ITEM --playlist-end $(($ITEM + $(($LIST_LENGTH - 1)))) -j "https://www.youtube.com$FEED">$HOME/git/magic-tape/json/channel_search.json
							echo -e "${Yellow}${bold}[Completed $FEED.]${normal}";

							jq '.channel_id' $HOME/git/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/channels/ids.txt;
							jq '.title' $HOME/git/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/channels/titles.txt;
							jq '.description' $HOME/git/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/channels/descriptions.txt;
							jq '.playlist_count' $HOME/git/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/channels/subscribers.txt;
							jq '.thumbnails[1].url' $HOME/git/magic-tape/json/channel_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/channels/img_urls.txt;

							cat /dev/null>$HOME/git/magic-tape/search/channels/thumbnails.txt;
							i=1;
								while [ $i -le $(cat $HOME/git/magic-tape/search/channels/ids.txt|wc -l) ];
								do		echo "url = \"https:""$(cat $HOME/git/magic-tape/search/channels/img_urls.txt|head -$i|tail +$i)\"">>$HOME/git/magic-tape/search/channels/thumbnails.txt;
								echo "output = \"$HOME/git/magic-tape/jpg/$(cat $HOME/git/magic-tape/search/channels/ids.txt|head -$i|tail +$i).jpg\"">>$HOME/git/magic-tape/search/channels/thumbnails.txt;
								((i++));
							done;
							echo -e "${Yellow}${bold}[Downloading channel thumbnails]${normal}";
							curl -s -K $HOME/git/magic-tape/search/channels/thumbnails.txt&echo -e "${Yellow}${bold}[Background downloading channel thumbnails]${normal}";
							if [ $ITEM -gt 1 ];then echo "Previous Page">>$HOME/git/magic-tape/search/channels/titles.txt;fi;
							if [ $(cat $HOME/git/magic-tape/search/channels/ids.txt|wc -l) -ge $LIST_LENGTH ];then echo "Next Page">>$HOME/git/magic-tape/search/channels/titles.txt;fi;
							echo "Abort Selection">>$HOME/git/magic-tape/search/channels/titles.txt;

							CHAN=" $(cat -n $HOME/git/magic-tape/search/channels/titles.txt|sed 's/^. *//g' |fzf\
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
							--preview='height=$(($FZF_PREVIEW_COLUMNS-8));\
							kitty icat --transfer-mode file  --clear;\
							i=$(echo {}|sed "s/\\t.*$//g");\
							echo $i>$HOME/git/magic-tape/search/channels/index.txt;\
							TITLE="$(cat $HOME/git/magic-tape/search/channels/titles.txt|head -$i|tail +$i)"\
							ll=0; while [ $ll -le $(($height/2 - 2)) ];do echo "";((ll++));done;\
							ll=1; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n "─";((ll++));done;\
							if [[ "$TITLE" == "Previous Page" ]];then draw_preview 1 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/git/magic-tape/png/previous.png;\
							elif [[ "$TITLE" == "Next Page" ]];then draw_preview 1 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/git/magic-tape/png/next.png;\
							elif [[ "$TITLE" == "Abort Selection" ]];\
							then draw_preview draw_preview 1 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/git/magic-tape/png/abort.png;\
							else draw_preview 1 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/git/magic-tape/jpg/"$(cat $HOME/git/magic-tape/search/channels/ids.txt|head -$i|tail +$i)".jpg;fi;\
							echo -e "\n\n$TITLE"|fold -w $FZF_PREVIEW_COLUMNS -s;\
							ll=1; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n "─";((ll++));done;\
								if [[ $TITLE != "Abort Selection" ]]&&[[ $TITLE != "Next Page" ]]&&[[ $TITLE != "Previous Page" ]];\
								then SUBS="$(cat $HOME/git/magic-tape/search/channels/subscribers.txt|head -$i|tail +$i)";\
							echo -e "\nSubscribers: ""$SUBS";\
							ll=1; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n "─";((ll++));done;\
							DESCRIPTION="$(cat $HOME/git/magic-tape/search/channels/descriptions.txt|head -$i|tail +$i)";\
							echo -e "\n$DESCRIPTION"|fold -w $FZF_PREVIEW_COLUMNS -s;\
							fi;')";
							kitty icat --transfer-mode file  --clear;
							i=$(cat $HOME/git/magic-tape/search/channels/index.txt);
							NAME=$(head -$i $HOME/git/magic-tape/search/channels/titles.txt|tail +$i);
							if [[ $CHAN == " " ]]; then echo "ABORT!"; NAME="Abort Selection";clear;fi;
							echo -e "Channel Selected: ${Yellow}${bold}$NAME${bold}";
							if [[ -n $PREVIOUS_PAGE ]]&&[[ $CHAN == *"shift-left"* ]]; then NAME="Previous Page";fi;
							if [[ $CHAN == *"shift-right"* ]]; then NAME="Next Page";fi;
							if [[ $NAME == "Next Page" ]];then ITEM=$(($ITEM + $LIST_LENGTH));fi;
							if [[ $NAME == "Previous Page" ]];then ITEM=$(($ITEM - $LIST_LENGTH));fi;
							if [[ $NAME == "Abort Selection" ]];then repeat_channel_search=0;fi;
							if [[ "$NAME" != "Abort Selection" ]]&&[[ "$NAME" != "Next Page" ]]&&[[ "$NAME" != "Previous Page" ]];
							then SUB_URL="$(head -$i $HOME/git/magic-tape/search/channels/ids.txt|tail +$i)";
								repeat_channel_search=0;
								echo -e " You will subscribe to this channel:\n${Yellow}${bold}$NAME${normal}\nProceed?(Y/y)"; read -N 1 pr;echo -e "\n";
								if [[ $pr == Y ]] || [[ $pr == y ]];
								then		notification_img="$HOME/git/magic-tape/jpg/""$(cat $HOME/git/magic-tape/search/channels/ids.txt|head -$i|tail +$i)"".jpg";
									if [ -n "$(grep -i $SUB_URL $HOME/git/magic-tape/subscriptions/subscriptions.txt)" ];
									then notify-send -t $NOTIF_DELAY -i "$notification_img" "You are already subscribed to $NAME ";
									else	echo "$SUB_URL"" ""$NAME">>$HOME/git/magic-tape/subscriptions/subscriptions.txt;
										notify-send -t $NOTIF_DELAY -i "$notification_img" "You have subscribed to $NAME ";
										mv "$notification_img" $HOME/git/magic-tape/subscriptions/jpg/"$SUB_URL.jpg";
										echo -e "${Red}${bold}NOTICE: ${Yellow}${bold}In order for this action to take effect in YouTube, you need to subscribe manually from a browser as well.\nDo you want to do it now? (Y/y)${normal}"|fold -w 75 -s;
										read -N 1 pr2;echo -e "\n";
										if [[ $pr2 == Y ]] || [[ $pr2 == y ]];then $BROWSER "https://www.youtube.com/channel/"$SUB_URL&echo "Opened $PREF_BROWSER";fi;
									fi;
								fi;
							fi;
							done;
						fi;
					;;
					u) clear;U="$(cat $HOME/git/magic-tape/subscriptions/subscriptions.txt|cut -d' ' -f2-|rofi -dmenu -i -p "❌ Unsubscribe from channel" -l 20 -width 40)";
								if [[ -z "$U" ]];	then empty_query;
	 						else	echo "$U";
	 						echo -e "Unsubscribe from this channel:\n"${Yellow}${bold}$U"${normal}\nProceed?(Y/y))";
	 						 read -N 1 uc;echo -e "\n";
									if [[ $uc == Y ]] || [[ $uc == y ]];
									then	notification_img="$HOME/git/magic-tape/png/magic-tape.png";
										sed -i "/$U/d" $HOME/git/magic-tape/subscriptions/subscriptions.txt;
										echo -e "${Yellow}${bold}[Unsubscribed from $U ]${normal}";
										notify-send -t $NOTIF_DELAY -i "$notification_img" "You have unsubscribed from $U";
										echo -e "${Red}${bold}NOTICE: ${Yellow}${bold}In order for this action to take effect in YouTube, you need to unsubscribe manually from a browser as well.\nDo you want to do it now? (Y/y)${normal}"|fold -w 75 -s;
										read -N 1 uc2;echo -e "\n";
										if [[ $uc2 == Y ]] || [[ $uc2 == y ]];then $BROWSER "https://www.youtube.com/feed/channels"&echo "Opened $PREF_BROWSER";fi;
									fi;
								fi;uc="";uc2="";
			;;
			H) clear;echo -e "Clear ${Yellow}${bold}watch history?${normal}(Y/y))";
					 read -N 1 cwh;echo -e "\n";
						if [[ $cwh == Y ]] || [[ $cwh == y ]];
						then cat /dev/null >	$HOME/git/magic-tape/history/watch_history.txt;
							notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "Watch history cleared.";
						fi;cwh="";
			;;
			S) clear;echo -e "Clear ${Yellow}${bold}search history?${normal}(Y/y))";
					 read -N 1 csh;echo -e "\n";
						if [[ $csh == Y ]] || [[ $csh == y ]];
						then cat /dev/null >	$HOME/git/magic-tape/history/search_history.txt;
						notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "Search history cleared.";
						fi;csh="";
			;;
			T) clear;echo -e "Clear ${Yellow}${bold}thumbnail cache?${normal}(Y/y))";
						 read -N 1 ctc;echo -e "\n";
							if [[ $ctc == Y ]] || [[ $ctc == y ]];
							then mv	$HOME/git/magic-tape/jpg/* $HOME/.local/share/Trash/files/
							notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "Thumbnail cache cleared.";
							fi;ctc="";
			;;
			l) clear;like_video;
						picposy=1;
						clear;
			;;
			L) clear;UNLIKE="$(cat $HOME/git/magic-tape/history/liked.txt|cut -d' ' -f2-|rofi -dmenu -i -p "❌ Select video to unlike" -l 20 -width 40)";
						if [[ -z "$UNLIKE" ]];	then empty_query;
						else	echo -e "${Yellow}${bold}Unlike video\n"$UNLIKE"?${normal}\n(Y/y))";
						 read -N 1 uv;echo -e "\n";
							if [[ $uv == Y ]] || [[ $uv == y ]];
							then	notification_img="$HOME/git/magic-tape/png/magic-tape.png";
								#UNLIKE="$(echo "$UNLIKE"|awk '{print $1}'|sed 's/^.*\///')";
								sed -i "/$UNLIKE/d" $HOME/git/magic-tape/history/liked.txt;
								notify-send -t $NOTIF_DELAY -i "$notification_img" "❌ You have unliked $UNLIKE";
							fi;
						fi;uv="";
						picposy=1;
			;;
			q) clear;picposy=1;
			;;
			*)kitty +kitten icat --clear;echo -e "\n😕${Yellow}${bold}$db2${normal} is an invalid key, please try again.\n"; sleep $DIALOG_DELAY;clear;
			;;
		esac
	done
	db2="";
}


function draw_preview {
	#sample draw_preview 35 35 90 3 /path/image.jpg
	kitty icat  --transfer-mode file --place $3x$4@$1x$2 --scale-up   "$5"
}

function get_feed_json ()
{
	echo -e "${Yellow}${bold}[Downloading $FEED...]${normal}";
	echo -e "$db\n$ITEM\n$FEED\n$fzf_header">$HOME/git/magic-tape/history/last_action.txt;
	yt-dlp --cookies-from-browser $PREF_BROWSER --flat-playlist --extractor-args youtubetab:approximate_date --playlist-start $ITEM --playlist-end $(($ITEM + $(($LIST_LENGTH - 1)))) -j "https://www.youtube.com$FEED">$HOME/git/magic-tape/json/video_search.json
	echo -e "${Yellow}${bold}[Completed $FEED.]${normal}";
}

function get_data ()
{
	jq '.id' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/ids.txt;
	jq '.title' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/titles.txt;
	jq '.duration_string' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/lengths.txt;
	jq '.url' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/urls.txt;
	jq '.timestamp' $HOME/git/magic-tape/json/video_search.json>$HOME/git/magic-tape/search/video/timestamps.txt;
	jq '.description' $HOME/git/magic-tape/json/video_search.json>$HOME/git/magic-tape/search/video/descriptions.txt;
	jq '.view_count' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/views.txt;
	jq '.channel_id' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/channel_ids.txt;
	jq '.channel' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/channel_names.txt;
	jq '.thumbnails[0].url' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'|sed 's/\.jpg.*$/\.jpg/g'>$HOME/git/magic-tape/search/video/image_urls.txt;
	jq '.live_status' $HOME/git/magic-tape/json/video_search.json>$HOME/git/magic-tape/search/video/live_status.txt;
	epoch="$(jq '.epoch' $HOME/git/magic-tape/json/video_search.json|head -1)";
	Y_epoch="$(date --date=@$epoch +%Y|sed 's/^0*//')";
	M_epoch="$(date --date=@$epoch +%m|sed 's/^0*//')";
	D_epoch="$(date --date=@$epoch +%j|sed 's/^0*//')";
	if [[ $db == "c" ]];
	then jq '.playlist_uploader' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/channel_names.txt;
		jq '.playlist_uploader_id' $HOME/git/magic-tape/json/video_search.json|sed 's/"//g'>$HOME/git/magic-tape/search/video/channel_ids.txt;
		fi;
	cat /dev/null>$HOME/git/magic-tape/search/video/thumbnails.txt;
	cat /dev/null>$HOME/git/magic-tape/search/video/shared.txt;
	i=1;
	while [ $i -le $(cat $HOME/git/magic-tape/search/video/titles.txt|wc -l) ];
	do	img_path="$HOME/git/magic-tape/jpg/img-$(cat $HOME/git/magic-tape/search/video/ids.txt|head -$i|tail +$i).jpg";
		if [ ! -f  "$img_path" ];
		then echo "url = \"$(cat $HOME/git/magic-tape/search/video/image_urls.txt|head -$i|tail +$i)\"">>$HOME/git/magic-tape/search/video/thumbnails.txt;
			echo "output = \"$img_path\"">>$HOME/git/magic-tape/search/video/thumbnails.txt;
			cp $HOME/git/magic-tape/png/wait.png $HOME/git/magic-tape/jpg/img-$(cat $HOME/git/magic-tape/search/video/ids.txt|head -$i|tail +$i).jpg
		fi;
		### parse approx date
		timestamp=$(cat $HOME/git/magic-tape/search/video/timestamps.txt|head -$i|tail +$i);
		if [[ $timestamp != "null" ]];then Y_timestamp="$(date --date=@$timestamp +%Y|sed 's/^0*//')";
			M_timestamp="$(date --date=@$timestamp +%m|sed 's/^0*//')";
			D_timestamp="$(date --date=@$timestamp +%j|sed 's/^0*//')";
			if [ $Y_epoch -gt $Y_timestamp ];then approximate_date="$(($Y_epoch-$Y_timestamp)) years ago";fi;
			if [ $Y_epoch -eq $(($Y_timestamp+1)) ];then approximate_date="One year ago";fi;
			if [ $Y_epoch -eq $Y_timestamp ]&&[ $M_epoch -gt $M_timestamp ];then approximate_date="$(($M_epoch-$M_timestamp)) months ago";fi;
			if [ $Y_epoch -eq $Y_timestamp ]&&[ $M_epoch -eq $(($M_timestamp+1)) ];then approximate_date="One month ago";fi;
			if [ $Y_epoch -eq $Y_timestamp ]&&[ $M_epoch -eq $M_timestamp ]&&[ $D_epoch -eq $D_timestamp ] ;then approximate_date="Today";fi;
			#yesterday=$(($D_timestamp+1));
			if [ $Y_epoch -eq $Y_timestamp ]&&[ $M_epoch -eq $M_timestamp ]&&[ "$D_epoch" -gt "$D_timestamp" ] ;then approximate_date="$(($D_epoch-$D_timestamp)) days ago";fi;
			if [ $Y_epoch -eq $Y_timestamp ]&&[ $M_epoch -eq $M_timestamp ]&&[ "$D_epoch" -eq $(($D_timestamp+1)) ] ;then approximate_date="Yesterday";fi;
		else approximate_date="$(head -$i $HOME/git/magic-tape/search/video/live_status.txt|tail +$i|sed 's/_/ /g;s/"//g')";
		fi;
		echo $approximate_date>>$HOME/git/magic-tape/search/video/shared.txt;
		((i++));
	done;
	echo -e "${Yellow}${bold}[Downloading thumbnails...]${normal}";
	curl -s -K $HOME/git/magic-tape/search/video/thumbnails.txt&	echo -e "${Yellow}${bold}[Background thumbnails download.]${normal}";
	if [ $ITEM -gt 1 ];then echo "Previous Page">>$HOME/git/magic-tape/search/video/titles.txt;fi;
	if [ $(cat $HOME/git/magic-tape/search/video/ids.txt|wc -l) -ge $LIST_LENGTH ];then echo "Next Page">>$HOME/git/magic-tape/search/video/titles.txt;fi;
	echo "Abort Selection">>$HOME/git/magic-tape/search/video/titles.txt;
}

function select_video ()
{
	PLAY="";
	PLAY=" $(cat -n $HOME/git/magic-tape/search/video/titles.txt|sed 's/^. *//g' |fzf\
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
	--preview='height=$(($FZF_PREVIEW_COLUMNS /4 + 1));\
	kitty icat --transfer-mode file  --clear;\
	i=$(echo {}|sed "s/\\t.*$//g");echo $i>$HOME/git/magic-tape/search/video/index.txt;\
	ll=0; while [ $ll -le $height ];do echo "";((ll++));done;\
	TITLE="$(cat $HOME/git/magic-tape/search/video/titles.txt|head -$i|tail +$i)";\
	channel_name="$(cat $HOME/git/magic-tape/search/video/channel_names.txt|head -$i|tail +$i)";\
	channel_jpg="$(cat $HOME/git/magic-tape/search/video/channel_ids.txt|head -$i|tail +$i)"".jpg";\
	if [[ "$TITLE" == "Previous Page" ]];then draw_preview 1 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/git/magic-tape/png/previous.png;\
	elif [[ "$TITLE" == "Next Page" ]];then draw_preview 1 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/git/magic-tape/png/next.png;\
	elif [[ "$TITLE" == "Abort Selection" ]];\
		then draw_preview 1 1 $(($FZF_PREVIEW_COLUMNS/2)) $(($FZF_PREVIEW_COLUMNS/2)) $HOME/git/magic-tape/png/abort.png;\
		else draw_preview 1 1 $FZF_PREVIEW_COLUMNS $height $HOME/git/magic-tape/jpg/img-"$(cat $HOME/git/magic-tape/search/video/ids.txt|head -$i|tail +$i)".jpg;\
		if [ -e $HOME/git/magic-tape/subscriptions/jpg/"$channel_jpg" ];\
			then draw_preview $(($FZF_PREVIEW_COLUMNS - 4 )) $height 4 4 $HOME/git/magic-tape/subscriptions/jpg/"$channel_jpg";\
			else draw_preview $(($FZF_PREVIEW_COLUMNS - 4 )) $height 4 4 $HOME/git/magic-tape/png/magic-tape.png;\
		fi;\
	fi;\
	ll=1; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n "─";((ll++));done;\
	echo -e "\n$TITLE"|fold -w $FZF_PREVIEW_COLUMNS -s;	\
	ll=1; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n "─";((ll++));done;\
	if [[ $TITLE != "Abort Selection" ]]&&[[ $TITLE != "Previous Page" ]]&&[[ $TITLE != "Next Page" ]];\
	then 	LENGTH="$(cat $HOME/git/magic-tape/search/video/lengths.txt|head -$i|tail +$i)";\
		echo -e "\nLength: $LENGTH";\
		SHARED="$(cat $HOME/git/magic-tape/search/video/shared.txt|head -$i|tail +$i)";\
		echo  "Shared: $SHARED"; \
		VIEWS="$(cat $HOME/git/magic-tape/search/video/views.txt|head -$i|tail +$i)";\
		echo  "Views : ""$VIEWS";\
		if [[ $db != "c" ]];\
		then ll=1; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n "─";((ll++));done;\
			echo -e "\nChannel: ""$channel_name"|fold -w $FZF_PREVIEW_COLUMNS -s;\
		fi;\
		DESCRIPTION="$(cat $HOME/git/magic-tape/search/video/descriptions.txt|head -$i|tail +$i)";\
		if [[ $DESCRIPTION != "null" ]];
		then ll=1; while [ $ll -le $FZF_PREVIEW_COLUMNS ];do echo -n "─";((ll++));done;\
			echo -e "\n$DESCRIPTION"|fold -w $FZF_PREVIEW_COLUMNS -s;	\
		fi;
	fi;')";
	kitty icat --transfer-mode file  --clear;
	i=$(cat $HOME/git/magic-tape/search/video/index.txt);
		notification_img="$HOME/git/magic-tape/jpg/img-"$(cat $HOME/git/magic-tape/search/video/ids.txt|head -$i|tail +$i)".jpg";
	play_now="$(head -$i $HOME/git/magic-tape/search/video/urls.txt|tail +$i)";
	TITLE=$(head -$i $HOME/git/magic-tape/search/video/titles.txt|tail +$i);
	channel_name="$(cat $HOME/git/magic-tape/search/video/channel_names.txt|head -$i|tail +$i)";

	if [[ -n $PREVIOUS_PAGE ]]&&[[ $PLAY == *"shift-left"* ]]; then TITLE="Previous Page";fi;
	if [[ $PLAY == *"shift-right"* ]]; then TITLE="Next Page";fi;
	if [[ $TITLE == "Next Page" ]];then ITEM=$(($ITEM + $LIST_LENGTH));fi;
	if [[ $TITLE == "Previous Page" ]];then ITEM=$(($ITEM - $LIST_LENGTH));fi;
	if [[ $TITLE == "Abort Selection" ]];then big_loop=0;fi;
	if [[ $PLAY == " " ]]; then echo "ABORT!"; TITLE="Abort Selection";big_loop=0;clear;fi;
	PLAY="";
}

function download_video ()
{
	cd $HOME/Desktop;
	echo -e "${Yellow}${bold}[Downloading $play_now${normal}...]";
	notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/download.png "Video Downloading: $TITLE";
	yt-dlp "$play_now";
	notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "Video Downloading of $TITLE is now complete.";
	echo -e "${Yellow}${bold}[Video Downloading of $TITLE is now complete.]${normal}";
	sleep $DIALOG_DELAY;
	cd ;
	clear;
}

function download_audio ()
{
	cd $HOME/Desktop;
	echo -e "${Yellow}${bold}[Downloading audio  of $play_now...]${normal}";
	notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/download.png "Audio Downloading: $TITLE";
	yt-dlp --extract-audio --audio-quality 0 --embed-thumbnail "$play_now";
	notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "Audio Downloading of $TITLE is now complete.";
	echo -e "${Yellow}${bold}[Audio Downloading of $TITLE is now complete.]${normal}";
	sleep $DIALOG_DELAY;
	cd ;
	clear;
}

function message_audio_video ()
{
	echo -e "${Yellow}${bold}[Playing: $play_now]\n[Title  : $TITLE]\n[Channel: $channel_name]${normal}";
	if [[ -n "$play_now" ]] && [[ -n "$TITLE" ]] && [[ -z "$(grep "$play_now" $HOME/git/magic-tape/history/watch_history.txt)" ]];
	then	echo "$play_now"" ""$TITLE">>$HOME/git/magic-tape/history/watch_history.txt;
	fi;
 notify-send -t $NOTIF_DELAY -i "$notification_img" "Playing: $TITLE";
	clear;
}

function select_action ()
{
	clear;
	kitty icat --transfer-mode file  --clear;
	#while [ "$ACTION" != "P" ]  && [ "$ACTION" != "V" ] && [ "$ACTION" != "A" ] && [ "$ACTION" != "W" ] && [ "$ACTION" != "Q" ] ;
	#do
	ACTION="$(echo -e "Play ⭐Video 360p\nPlay ⭐⭐Video 720p\nPlay ⭐⭐⭐Best Video/Live\nPlay ⭐⭐⭐Best Audio\nDownload Video 🔽\nDownload Audio 🔽\nLike Video ❤️\nQuit ❌"|rofi -dmenu -i -p "🔎 What do you want to do?" -l 8 -width 22 -selected-row 0)";
	case $ACTION in
		"Play ⭐Video 360p") message_audio_video;print_mpv_video_shortcuts;mpv --ytdl-raw-options=format=18 "$play_now";play_now="";TITLE="";
		;;
		"Play ⭐⭐Video 720p") message_audio_video;print_mpv_video_shortcuts;	mpv --ytdl-raw-options=format=22 "$play_now";play_now="";TITLE="";
		;;
		"Play ⭐⭐⭐Best Video/Live") message_audio_video;print_mpv_video_shortcuts;mpv "$play_now";play_now="";TITLE="";play_now="";TITLE="";
		;;
		"Play ⭐⭐⭐Best Audio") message_audio_video;print_mpv_audio_shortcuts;mpv --ytdl-raw-options=format=ba "$play_now";play_now="";TITLE="";
		;;
		"Download Video 🔽") clear;download_video;kitty +kitten icat --clear;echo -e "\n${Yellow}${bold}[Video Download complete.]\n${normal}";
		;;
		"Download Audio 🔽") clear;download_audio;kitty +kitten icat --clear;echo -e "\n${Yellow}${bold}[Audio Download complete.${normal}\n";
		;;
		"Like Video ❤️") clear;
			if [[ -z "$(grep "$play_now" $HOME/git/magic-tape/history/liked.txt)" ]];
			then echo "$play_now"" ""$TITLE">>$HOME/git/magic-tape/history/liked.txt;
			notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "❤️ Video added to Liked Videos.";
			else notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "❤️ Video already added to Liked Videos.";
			fi;
		;;
		"Quit ❌") clear;
		;;
		*)kitty +kitten icat --clear;echo -e "\n😕${Yellow}${bold}$db${normal} is an invalid key, please try again.\n"; sleep $DIALOG_DELAY;clear;
		;;
	esac
	#done
	ACTION="";
}

function select_action1 ()
{
	clear;
	kitty icat --transfer-mode file  --clear;
	while [ "$ACTION" != "P" ]  && [ "$ACTION" != "V" ] && [ "$ACTION" != "A" ] && [ "$ACTION" != "W" ] && [ "$ACTION" != "Q" ] ;
	do
		 ACTION="$(echo -e "Play the video/audio ▶️\nWatch livestream 📡\nVideo  download 🔽\nAudio download 🔽\nLike Video ❤️\nQuit ❌"|rofi -dmenu -i -p "🔎 What do you want to do?" -l 5 -width 22 -selected-row 0 |cut -b1)";
	case $ACTION in
		W) clear;	echo -e "${Yellow}${bold}[Playing: $play_now]\n[Title  : $TITLE]${normal}";
					if [[ -n "$play_now" ]] && [[ -n "$TITLE" ]];
					then	echo "$play_now"" ""$TITLE">>$HOME/git/magic-tape/history/watch_history.txt;
					fi;
					notify-send -t $NOTIF_DELAY -i "$notification_img" "Playing: $TITLE"&print_mpv_video_shortcuts;
					mpv "$play_now";
				;;
				P) clear;play_video;
				;;
				V) clear;download_video;kitty +kitten icat --clear;echo -e "\n${Yellow}${bold}[Video Download complete.]\n${normal}";
				;;
				A) clear;download_audio;kitty +kitten icat --clear;echo -e "\n${Yellow}${bold}[Audio Download complete.${normal}\n";
				;;
				L) clear;
							if [[ -z "$(grep "$play_now" $HOME/git/magic-tape/history/liked.txt)" ]];
							then echo "$play_now"" ""$TITLE">>$HOME/git/magic-tape/history/liked.txt;
							notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "❤️ Video added to Liked Videos.";
							else notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "❤️ Video already added to Liked Videos.";
							fi;
				;;
				Q) clear;
				;;
				*)kitty +kitten icat --clear;echo -e "\n😕${Yellow}${bold}$db${normal} is an invalid key, please try again.\n"; sleep $DIALOG_DELAY;clear;
				;;
			esac
	done
	ACTION="";
}

function empty_query ()
{
	clear;
 echo "😕 Selection cancelled...";
 sleep $DIALOG_DELAY;
}
###############################################################################
export -f draw_preview
Yellow="\033[1;33m"
Green="\033[1;32m"
Red="\033[1;31m"
Magenta="\033[1;35m"
Cyan="\033[1;36m"
bold=`tput bold`
normal=`tput sgr0`
picposy=1;
db=""
if [[ ! -e $HOME/git/magic-tape/config.txt ]]||[ $(cat $HOME/git/magic-tape/config.txt|wc -l) -lt 6 ];
then setup;
fi;
PREF_BROWSER="$(head -1 $HOME/git/magic-tape/config.txt)";
BROWSER="$(head -2 $HOME/git/magic-tape/config.txt|tail +2)";
LIST_LENGTH="$(head -3 $HOME/git/magic-tape/config.txt|tail +3)";
DIALOG_DELAY="$(head -4 $HOME/git/magic-tape/config.txt|tail +4)";
NOTIF_DELAY="$(head -5 $HOME/git/magic-tape/config.txt|tail +5)";
COLOR="$(head -6 $HOME/git/magic-tape/config.txt|tail +6)";
color_set;
while [ "$db" != "q" ]
do
	kitty +kitten icat --clear
	kitty +kitten icat  --place 6x6@1x$picposy $HOME/git/magic-tape/png/magic-tape.png
 echo "╭──────────────────────────────────────────╮"
 echo -e "│      ${Yellow}${bold}┏┳┓┏━┓┏━╸╻┏━╸   ╺┳╸┏━┓┏━┓┏━╸${normal}        │"
 echo -e "│      ${Yellow}${bold}┃┃┃┣━┫┃╺┓┃┃  ╺━╸ ┃ ┣━┫┣━┛┣╸ ${normal}        │"
 echo -e "│      ${Yellow}${bold}╹ ╹╹ ╹┗━┛╹┗━╸    ╹ ╹ ╹╹  ┗━╸${normal}  Enter:│"
 echo  "├──────────────────────────────────────────┤"
 echo -e "│ ${Yellow}${bold}f ${normal}${Red}to browse Subscriptions Feed.${normal}          │\n│ ${Yellow}${bold}t ${Red}to browse Trending Feed.${normal}               │\n│ ${Yellow}${bold}s${normal} ${Green}to Search for a key word/phrase.${normal}       │\n│ ${Yellow}${bold}r ${Green}to Repeat previous action.${normal}             │\n│ ${Yellow}${bold}c ${Green}to select a Channel Feed.${normal}              │\n│ ${Yellow}${bold}l ${Magenta}to browse your Liked Videos.${normal}           │\n│ ${Yellow}${bold}h ${Magenta}to browse your Watch History${normal}.          │\n│ ${Yellow}${bold}j ${Magenta}to browse your Search History.${normal}         │\n│ ${Yellow}${bold}m ${Cyan}for Miscellaneous Menu.${normal}                │\n│ ${Yellow}${bold}q ${Cyan}to Quit${normal}.                               │"
 echo  "╰──────────────────────────────────────────╯"
 echo -en "Select: ";read -N 1  db
 case $db in
  f) clear;kitty +kitten icat --clear;
   		big_loop=1;
   		ITEM=1;
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
 	 		picposy=1;clear;
  ;;
  t) clear;kitty +kitten icat --clear;
   		big_loop=1;
   		ITEM=1;
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
 	 		picposy=1;clear;
  ;;
  s) clear;
  			kitty +kitten icat --clear;
  			kitty +kitten icat  --place 6x6@0x0 $HOME/git/magic-tape/png/search.png;
  			echo -e "\tEnter keyword/keyphrase\n\tto search for: \n";
  			read  P;
   		kitty +kitten icat --clear;
   		if [[ -z "$P" ]];
   			then empty_query;
   		else P=${P// /+};
   			echo "$P">>$HOME/git/magic-tape/history/search_history.txt;
   			big_loop=1;
   			ITEM=1;
   			FEED="/results?search_query=""$P""&sp=CAASAhAB";
   			while [ $big_loop -eq 1 ];
   			do fzf_header="$(echo ${FEED^^}|sed 's/&SP=.*$//;s/^.*SEARCH_QUERY=/search: /;s/[\/\?=&+]/ /g') videos: $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
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
 	 		picposy=1;clear;
  ;;
  r) clear;
				 kitty +kitten icat --clear;
				 db="$(head -1 $HOME/git/magic-tape/history/last_action.txt)";
				 ITEM="$(head -2 $HOME/git/magic-tape/history/last_action.txt|tail +2)";
				 FEED="$(head -3 $HOME/git/magic-tape/history/last_action.txt|tail +3)";
				 fzf_header="$(head -4 $HOME/git/magic-tape/history/last_action.txt|tail +4)";

  			big_loop=1;
  			first=1;
  			while [ $big_loop -eq 1 ];
  			do	if [ $first -eq 0 ];then fzf_header="$(echo ${FEED^^}|sed 's/&SP=.*$//;s/^.*SEARCH_QUERY=/search: /;s/[\/\?=]/ /g') videos $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";get_feed_json;get_data;fi;
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
				 picposy=1;
				 clear;
  ;;
  c) clear;kitty +kitten icat --clear;
  			C="$(cat $HOME/git/magic-tape/subscriptions/subscriptions.txt|cut -d' ' -f2-|rofi -dmenu -i -p "🔎 Select channel" -l 20 -width 40)";
  			echo -e "${Yellow}${bold}[Selected channel: $C]"${normal};
  			if [[ -z "$C" ]];
   		then empty_query;
  			else P="$(grep "$C" $HOME/git/magic-tape/subscriptions/subscriptions.txt|head -1|awk '{print $1}')"
  			big_loop=1;
  				ITEM=1;
   			FEED="/channel/""$P""/videos";
   			while [ $big_loop -eq 1 ];
   			do	fzf_header="channel: $C  videos $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
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
  ;;
  h) clear;kitty +kitten icat --clear;
  			TITLE="$(tac $HOME/git/magic-tape/history/watch_history.txt|cut -d' ' -f2-|rofi -dmenu -i -p "🔎 Select previous video" -l 20 -width 40)";
  			if [[ "$TITLE" == "" ]];
   			then empty_query;
  			else 	play_now="$(grep "$TITLE" $HOME/git/magic-tape/history/watch_history.txt|head -1|awk '{print $1}')";
					notification_img="$HOME/git/magic-tape/jpg/img-"${play_now##*=}".jpg";
						select_action;
  			fi;
  			picposy=1;
  			clear;
  ;;
  j) clear;kitty +kitten icat --clear;
  		 P="$(tac $HOME/git/magic-tape/history/search_history.txt|sed 's/+/ /g'|rofi -dmenu -i -p "🔎 Select key word/phrase" -l 20 -width 40)";
  			if [[ -z "$P" ]];
   		then empty_query;
  			else P=${P// /+};
   			big_loop=1;
   			ITEM=1;
   			FEED="/results?search_query=""$P""&sp=CAASAhAB";
   			while [ $big_loop -eq 1 ];
   			do fzf_header="$(echo ${FEED^^}|sed 's/&SP=.*$//;s/^.*SEARCH_QUERY=/search: /;s/[\/\?=&+]/ /g') videos: $ITEM to $(($ITEM + $(($LIST_LENGTH - 1))))";
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
 	 		picposy=1;clear;
  ;;
  l) clear;kitty +kitten icat --clear;
  			TITLE="$(tac $HOME/git/magic-tape/history/liked.txt|cut -d' ' -f2-|rofi -dmenu -i -p "❤️ Select liked video" -l 20 -width 40)";
  			if [[ -z "$TITLE" ]];
   		then empty_query;
  			else 	play_now="$(grep "$TITLE" $HOME/git/magic-tape/history/liked.txt|head -1|awk '{print $1}')";
  				notification_img="$HOME/git/magic-tape/jpg/img-"${play_now##*=}".jpg";
						select_action;
  			fi;
  			picposy=1;
  			clear;
  ;;
  m) clear;kitty +kitten icat --clear;misc_menu;
  ;;
  q) clear;kitty +kitten icat --clear;notify-send -t $NOTIF_DELAY -i $HOME/git/magic-tape/png/magic-tape.png "Exited magic-tape";
  ;;
  *)clear;kitty +kitten icat --clear;echo -e "\n${Yellow}${bold}$db${normal} is an invalid key, please try again.\n";picposy=4;
  ;;
 esac
done
