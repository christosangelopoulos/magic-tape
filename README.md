# magic-tape
Magic-tape is an image supporting fuzzy finder command line interface YouTube client.

Downloading data is achieved with [yt-dlp](https://github.com/yt-dlp/yt-dlp) and  [cURL](https://curl.se/), while selections are achieved mainly with [fzf](https://github.com/junegunn/fzf).

Image support is achieved either with [kitty terminal](https://sw.kovidgoyal.net/kitty/),  [ueberzugpp](https://github.com/jstkdng/ueberzugpp), [ueberzug](https://github.com/seebye/ueberzug) or [chafa](https://github.com/hpjansson/chafa).



With magic-tape, through the __main menu__, the user can

  * Browse  videos from __subscriptions__.

  * Browse videos suggested by __YT algorithm__.

  * Browse through __trending__ video feed.

  * make a video __search__, using keywords or phrases.

  * Watch a previously watched video (__watch history__).

  * Browse videos from a __subcsribed channel__.

  * Watch a __liked__ video.

  * Repeat the __previous__ selection.

  * Repeat a previous search (__search history__).

  * __Watch/download__ video/audio content, in various formats.



Through the __miscellaneous menu__ the user can

  * __Edit Preferences file__ (configuration).

  * __Easily Update yt-dlp command__ (the driving force of this script).

  * __Like__ / __Unlike__ a video.

  * __Synchronize__ the above actions with their YouTube account.

  * __Import subscriptions__ from YouTube.

  * __Subscribe__ to/ __Unsubscribe__ from a channel.

  * __Clear__ their watch/search __history__, __liked__ videos, thumbnail __cache__.

---

## Dependencies

Instructions on installing yt-dlp can be found here:

[https://github.com/yt-dlp/yt-dlp#installation](https://github.com/yt-dlp/yt-dlp#installation)

Easily install yt-dlp using pip:

```
pip install yt-dlp
```

Other dependencies include:

- [Bash](https://www.gnu.org/software/bash/) (version >= 4.2)

* [cURL](https://curl.se/)

* [rofi](https://github.com/davatorium/rofi)

* [fzf](https://github.com/junegunn/fzf)

* [mpv](https://github.com/mpv-player/mpv)

* [jq](https://stedolan.github.io/jq/)

* [xclip](https://github.com/astrand/xclip)

* [dmenu](http://tools.suckless.org/dmenu/)

Regarding image support, it can either be achived with

* [kitty terminal](https://sw.kovidgoyal.net/kitty/)


```
sudo apt install kitty
```

with

* [ueberzugpp](https://github.com/jstkdng/ueberzugpp) (install instructions in the page)

    Ueberzugpp works great with older hardware, where installing kitty is not an option.

with

* [chafa](https://github.com/hpjansson/chafa)


```
sudo apt install chafa
```

or with

* [ueberzug](https://github.com/seebye/ueberzug)

---

---
## How to install Ueberzug

 The [ueberzug](https://github.com/seebye/ueberzug) project has been archived. However, in order to install `ueberzug` one can follow these steps:

- Install dependencies

```
sudo apt install libx11-dev libxres-dev libxext-dev
```
If during the installation process, errors appear due to absence of other depedencies, the user is encouraged to search the error message in the internet in order to locate the misssing dependency.

- Follow the install instructions found in [this ueberzug fork](https://github.com/gokberkgunes/ueberzug-tabbed):

```
git clone "https://github.com/gokberkgunes/ueberzug-tabbed.git"

cd ueberzug-tabbed

python -m pip install .

```

**NOTE**: One may need to call above `pip install` commands as `pip install --break-system-packages` to successfully install the packages.

---

---

To install these `magic-tape.sh `dependencies, run the following command:

```
sudo apt install curl fzf mpv jq xclip
```

To install `rofi`:

```
sudo apt install rofi
```

To install `dmenu`:

```
sudo apt install dmenu
```

## Note for macOS users

macOS has an outdated version of Bash (v3). You need to install the latest bash version using Homebrew:

```sh
brew install bash
```

Then install GNU utils used by the script (`echo`, `sed`, `head`, `tail`):

```sh
brew install gnu-sed coreutils

# Add this to your shellrc (.basrc, .zshrc, ...)
# Adapt to the location of your homebrew installation path.
export HOMEBREW_PREFIX=/opt/homebrew
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
```

Finally install the remaining dependencies:

```sh
brew install curl fzf mpv jq yt-dlp
```

---

## Install

Clone the `magic-tape` repo, and then get to the `magic-tape/` directory:

```
git clone https://gitlab.com/christosangel/magic-tape.git
```
```
cd magic-tape/
```
Make `install.sh` executable, then run it:

```
chmod +x install.sh&&./install.sh
```
That's it, the script is now installed.

---

## Run

To run the script from the same directory, run:

```
./magic-tape.sh
```

or from any directory, provided that `~/.local/bin/` is added to the $PATH:

```
magic-tape.sh
```

---

---


## Configuring

Through the `P Option` in the `Miscellaneous Menu`,  the user can configure many pamaters of this script. The same can be equally well achieved by editing the `~/.config/magic-tape/magic-tape.conf`file, outside the script  :

![configure.png](screenshots/configure.png){height=300}



|n|Variable|Explanation|Default Value|Acceptable Values|
|---|---|---|---|---|
|1|`PREF_SELECTOR`| Preferred selector is the program used to select actions |`rofi` | dmenu rofi fzf|
|2|`PREF_EDITOR`|Editor used to edit the configuration file|`${EDITOR-nano`}|nano, vim, gedit, xed, or any other terminal or graphical text editor|
|3|`PREF_BROWSER`|Preferred browser is the browser the cookies of which are used to login to YouTube |`firefox`|brave-browser-stable, chrome, chromium, edge, firefox, opera, vivaldi|
|4|`LINK_BROWSER`|The browser to use to open links with|`firefox`|Any Browser|
|5|`LIST_LENGTH`|The length of the list of videos to choose from|`40`|5 - 99 (the smaller the length, the faster the response)
|6|`TERMINAL_MESSAGE_DURATION`|Terminal message duration (sleep command)|`2`|1 - 5 sec (or more, if you love sleeping)
|7|`COLORED_MESSAGES`|Tui messages in color|`yes`|yes / no|
|8|`NOTIFICATION_ENABLED`|Enable desktop notifications|`yes`|yes / no|
|9|`NOTIFICATION_DURATION`| Notification duration|`6000`|1 - 10000 msec|
|10|`IMAGE_SUPPORT`|Image support, the program used to render image previews in the terminal window.| `ueberzug`|  kitty  ueberzugpp  ueberzug  chafa  none|
|11|`COMMENTS_TOGGLE`|Show comments and description in the terminal, while video is reproduced.|`yes`|yes / no |
|12|`COMMENTS_MAX`|Maximum comments number loaded.|`100`|any number, or __all__ for all comments.|
|13|`COMMENTS_REPLIES_MAX`|Maximum comment replies, number of replies loaded per comment. (Further info:$ `man yt-dlp`).|`5`|any number, or __all__ for all comment replies.|
|14|`COMMENTS_SORT`|Comments sort method, the order in which comments are shown. Choose comment sorting mode(on YouTube's side). (Further info:$ `man yt-dlp`).|`new`|new, old, top |
|15|`PINNED_COMMENTS`| Show pinned comment (if any) as first or last in the comment section.|`last`|first / last|
|16|`SHOW_MPV_KEYBINDINGS`| Show mpv keybindings while playing |`yes`| yes / no|
|17|`DOWNLOAD_DIRECTORY`|Directory to download audio video into| `/Downloads`| `$HOME` is the root directory, e.g. if you want to download your files in the Desktop directory, instead of `$HOME/Desktop`, just put `/Desktop`

Finally, by editing the `~/.config/magic-tape/magic-tape.conf file`,  the format of the preferred selector program can be also configured. However the user is advised to **avoid such editing, unless they know what they are doing**.

---

## USAGE
---

---
## FIRST STEP: Import Subscribed channels

When the script is run for the first time, it would be advisable for the user to __import their subcsribed channels from YouTube__.

The user user can do that by navigating to the __Miscellaneous Menu (option m)__, then selecting __Import Subscriptions from YouTube (option I)__.


![misc_option.png](screenshots/misc_option.png){height=300}then:
![import_subscriptions.png](screenshots/import_subscriptions.png){height=300}

---

---

## Main Menu

Once the program is run, the user is presented with the __Main Menu:__

![main.png](screenshots/main.png){height=320}

Entering the respective key, the user can :

|key| Action|
|--|--|
|__f__|Browse their Subscriptions __Feed__.|
|__y__|Browse __YT__ algorithm Feed|
|__t__|Browse YouTube __Trending__ Feed.
|__s__|__Search__ for a key word/phrase|
|__r__|__Repeat__ previous selection.|
|__c__|Select a Subscribed __Channel Feed__.|
|__l__|Browse __Liked__ Videos.|
|__h__|Browse __Watch History__.|
|__j__|Browse __Search History__.|
|__m__|Open __Miscellaneous Menu__.|
|__q__|__Quit__ the program.|

* In order for the `f and  y Options` to function, the user must already be logged in to YT in the browser.

* Selecting __channel feed__, Browsing __watch history, search history & liked videos__ is done with `rofi`, `fzf` or `dmenu`:

![image 3](screenshots/rofi_c_option.png){width=320}
![image 4](screenshots/fzf_history.png){width=320}
![image 5](screenshots/dmenu_liked.png){width=320}
![image 6](screenshots/rofi_j_option.png){width=320}

---

## Search and Search History

The user can search for a video using a keyword or phrase. Also the user can browse  __Search history__ and repeat a previous search.

 There is now a **duration filter prompt** in the **search** and **search history** option:

![image 7](screenshots/filter.png){width=320}

---

## Video selection

Video selection is done with __fzf__:

![image 8](screenshots/fzf1.png){height=450}

### Search shortcuts

|Shortcut|Function|
|---|---|
|Enter, Right Arrow|Accept|
|Esc|Abort Selection|
|Shift+Right Arrow|Next Page|
|Shift+Left Arrow|Previous Page|

Once a video is selected, the user is prompted to __select action__:

* Play ⭐ Video 144p

* Play ⭐⭐ Video 360p

* Play ⭐⭐⭐ Video 720p

* Play ⭐⭐⭐⭐ Best Video

* Play ⭐⭐⭐⭐ Best Audio

* Download Video 🔽

* Download Audio 🔽

* Like Video ❤️

* Browse Feed of channel that uploaded the video  📺

* Subscribe to the channel that uploaded the video 📋

* Open in browser 🌐


* Copy link 🔗


* Quit ❌

![image 9](screenshots/rofi_select_action.png){height=180}
![image 10](screenshots/fzf_select_action.png){height=180}
![image 11](screenshots/dmenu_select_action.png){height=180}

---

---

## Playing the video

While the video is reproduced, a shortcut cheatsheet will be printed to help the user control the mpv playing the video:

![shortcuts.png](screenshots/shortcuts.png){height=180}

---

## Miscellaneous Menu

The __m option__ of the Main Menu opens up the __Miscellaneous Menu__:

![misc.png](screenshots/misc.png){height=320}

Entering the respective key, the user can :

|key| Action|
|--|--|
|__P__|__Set Up__ Preferences.|
|__Y__|__Update__ `yt-dlp`.|
|__l__|__LIKE__ a video.|
|__L__|__UNLIKE__ a video.|
|__I__|__Import subscriptions__ from YouTube.|
|__n__|__Subscribe__ to a new channel.|
|__u__|__Unsubscribe__ to a new channel.|
|__H__|Clear __watch history__.|
|__S__|Clear __search  history__.|
|__T__|Clear __thumbnail cache__.|
|__q__|__Quit__ this menu, __Return__ to Main Menu.|

---

## Updating `yt-dlp`

With a hit of a key (__option Y__ in the Miscellaneous Menu), the user can __update `yt-dlp` command__, and keep using it (and magic-tape) without any hiccups:

![update_yt-dlp.png](screenshots/update_yt-dlp.png){height=320}

__NOTICE: Updating `yt-dlp` with this option works only when `yt-dlp` has been installed using pip__.

---

## Subscribing to a new channel

Selecting the __n option__ of the Miscellaneous Menu, the user can subscribe to a new channel.

Initially, the user is asked to enter a keyword / keyphrase to search channels with.

Channel selection then is made with __fzf__:

![image 13](screenshots/fzf2.png){height=320}

* In the __n & u options__ of the Miscellaneous Menu (subcribe/unsubscribe to a channel), after a selection, the user will be asked to sync the changes manually to their YouTube account.

---

---


## Viewing Video Description & Comments

Provided that the `COMMENTS_TOGGLE` variable is configured to `yes` in  `~/.config/magic-tape/magic-tape.conf` file (default `yes`), the video description as well as the comments written by YT viewers will be shown in the terminal window, while the video is reproduced.

![image 14](screenshots/comments.png){height=300}
![image 15](screenshots/comments1.png){height=300}
![image 16](screenshots/comments2.png){height=300}

Thus, the user can be satisfied reading other viewers having a swing at the politicians/celebrities/stars they love to hate, or, watch closely to their heart's content, as cyber nuclear attacks are launched between self-righteous, valiant and livid keyboard fighters.

The user can configure comments number, replies number and sorting, through three more variables in `~/.config/magic-tape/magic-tape.conf`file.

The user is also able to show pinned comments (if any) as first or last in the comment section.

Pinned comments will be marked accordingly and will be printed in different color to the other comments, in order to stand out.

Comment loading is asynchronous to video loading, so it is possible that there will be some delay in the appearence of the comments. That depends on the number of comments, network speed etc.

Also, it would be helpful to mention enabling __limitless scrolling__ through your terminal emulator's preferences, in order not to miss a post in video with many many comments.

---

---

## `zsh` Compatibility

If the user runs the script with `zsh`, the `$SHELL` will be automatically exported to `/bin/bash`. If any compatibility problrms arise, create an issue.

---

---

## Troubleshooting

The ___vast majority___ of the issues mentioned, had only to do with:

### A. Improper installation of the script.

If the user does't install properly the script, the script will not function. Proper installation is very easy,  just one line command in the terminal.

### B.  Out of date `yt-dlp` command.

In my experience, the best way to keep the _driving force_ of this script, that is `yt-dlp` __up-to-date__, one might:

- preferably __install it with `pip`__:

```
pip install yt-dlp
```

- Check regularly for updates, and __update easily__ with one command:

```
python3 -m pip install -U "yt-dlp[default]"
```

- To make things easier, just hit __Y__ and select __Update yt-dlp__ option from within the __Miscellaneous Menu__.




### C. Browser not logged-in causes problems.

`yt-dlp` uses browser cookies to function properly. So, Before opening magic-tape, make sure that you log in to yt in your browser, and the right values arre assigned to `PREF_BROWSER` and `LINK_BROWSER` in the config file.


If the user takes notice of these few points, chances are the experience with magic-tape  will be  at least satisfactory.

__Enjoy!__

---

---
