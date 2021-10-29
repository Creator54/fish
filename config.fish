set -gx TERM kitty
set -gx TERMINAL kitty
set -gx EDITOR vim
set -gx VISUAL vim
set -gx BROWSER brave
set -gx WALLPAPERS '/home/creator54/wallpapers'
set -gx CPLUS_INCLUDE_PATH /nix/store/s6scq5f4vk7pmxbch63byqw0zhf988j8-libc++-11.1.0/include/c++/v1
set -gx PAGER "bat"
#set -gx MANPAGER "bat"
set -gx NNN_PLUG 'f:finder;o:fzopen;p:preview-tui;d:diffs;t:nmount;v:imgview;g:!git log;'
set -gx NNN_FIFO '/tmp/nnn.fifo'
set up_cached '0'
set down_cached '0'
set -xg count '0' #set as environment variable so its doesnt gets reset on each new term

function cmd
	echo CMD: $argv; echo
	$argv
end

function __fish_command_not_found_handler --on-event fish_command_not_found
	set -l exit_string "You know what you are doing, right ?" "Are you sure about that ?" "Sorry can't find what you are looking for :(" "IDK what you mean !" "Invalid command !" "You in the right mood mate ?"
	set index (random 1 6)
	printf '%s\n' $exit_string[$index]
end

function he
	cmd home-manager edit
end

function hs
	cmd home-manager switch
end

function line
	tput smacs
		printf "%s\n" 'ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss'
  tput rmacs
end

function record
	set name (echo (date '+%a-%F')-$count)
	#	if string match -r 'vcam' $argv &> /dev/null
	#		cmd ffmpeg -f x11grab -i $DISPLAY.0 -i /dev/video0
	#		~/Screenrecords/$name+cam.mkv needs fixes
	if string match -r 'v|video|no audio' $argv &> /dev/null
		cmd ffmpeg -f x11grab -i $DISPLAY.0 ~/Screenrecords/$name.mkv
	else if string match -r 'cam|camera' $argv &> /dev/null
		cmd ffmpeg -i /dev/video0 ~/Screenrecords/$name-cam.mkv
	else
		cmd ffmpeg -f x11grab -i $DISPLAY.0 -f alsa -i default -c:v libx264 -c:a flac ~/Screenrecords/$name.mkv #1 is for computer audio, 2 is for mic generally
	end
	set count (math $count +1)
end

function v
	if [ -z "$argv" ]
		echo "Do pass a file to view !"
	else if [ -d "$argv" ]
		echo Files Count: (count $argv/*); ls -sh $argv
	else if string match -r ".jpg|.png|.svg" $argv &> /dev/null
		view_pic $argv
	else if string match -r ".mp4|.mkv|.mp3" $argv &> /dev/null
		mpv $argv
	else if string match -q "*.pdf" $argv
		zathura $argv &> /dev/null
	else
		$PAGER $argv
	end
end

function s
	if [ $argv[1] = "-w" ]
		if string match -r '!' $argv[2] &>/dev/null
			exec $BROWSER $argv[2] $argv[3]
		else
			printf "From the WEB 2.0"
			ddgr $argv[2]
		end
	else if [ $argv[1] = "-l" ]
		printf "From nix-locate:\n\n"
		nix-locate $argv[2]
	else
		printf "From nix search:\n\n" && nix search $argv; or line && printf "\nFrom nix-locate:\n\n" && nix-locate bin/$argv
	end
end

function ssh-setup
	ssh-keygen -t ed25519 -C 'hi.creator54@gmail.com'
	eval (ssh-agent -c)
	ssh-add ~/.ssh/id_ed25519
	cat ~/.ssh/id_ed25519.pub | clip
	echo "Copied SSH Key to Clipboard, now paste it on Github."
end

function getip
	if string match -r 'github.io' $argv &> /dev/null
		dig $argv|sed -n 12p|cut -f3
	else
		dig $argv | sed -n 12p | cut -f6
	end
end

function ssd-price
	set amzn (curl -s 'https://www.amazon.in/Crucial-BX500-240GB-2-5-inch-CT240BX500SSD1/dp/B07G3YNLJB/ref=mp_s_a_1_3?dchild=1&keywords=ssd&qid=1634231023&qsid=257-2724214-9903254&sr=8-3&sres=B07G3YNLJB%2CB07KCGPRMQ%2CB076Y374ZH%2CB089QXQ1TV%2CB08FJB98F1%2CB07YFF3JCN%2CB078WYS5K6%2CB07WFNQ9JF%2CB093V4NHV5%2CB079T8BZMG%2CB07HCCWWWF%2CB099NSRP29%2CB08YYMG4X2%2CB07DJ2TP6H&srpt=COMPUTER_DRIVE_OR_STORAGE' -H 'user-agent: Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'| pup 'span#atfRedesign_priceblock_priceToPay' | head -n 6 | tail -n 1 | tr -d ,)
	set fk (curl -s 'https://www.flipkart.com/crucial-bx500-240-gb-laptop-desktop-internal-solid-state-drive-ct240bx500ssd1/p/itm47385821d256d?pid=ACCFNFUKF9BKE5PS&lid=LSTACCFNFUKF9BKE5PSURBYLC&marketplace=FLIPKART&q=ssd&store=6bo%2Fjdy&spotlightTagId=BestsellerId_6bo%2Fjdy&srno=s_1_3&otracker=search&otracker1=search&fm=SEARCH&iid=6418dbd6-8f52-4990-be00-efc3b03396cc.ACCFNFUKF9BKE5PS.SEARCH&ppt=sp&ppn=sp&ssid=fieava78gg0000001634230842661&qH=d4576b3b305e1df6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:92.0) Gecko/20100101 Firefox/92.0'| pup 'div' | head -n 334|tail -n 1 | awk '{$1=$1};1' | cut -c4- | tr -d ,)

	if bash -c '[ "$amzn" = "$fk" ]' #doesnt work in fish so ;(
		echo $fk/FK
	else if bash -c '[ "$amzn" -gt "$fk" ]'
		echo $fk/FK
	else
		echo $amzn/AMZN
	end
end

function phone
	ftp ftp://192.168.43.1:2221
end

function gpull
	git pull origin (git branch | sed 's/^* //')
end

function gpush
	if [ -z "$argv" ]
		git push origin (git branch | sed 's/^* //')
	else
		git push origin $argv
	end
end

function ga
	if [ -z "$argv" ]
		git add .
	else
		git add $argv
	end
end

#fetch battery left
function battery
	if [ -z "$argv" ]
		acpi -i
		#upower -i (upower -e | grep 'BAT') | grep -E "state|time\ to\ full|percentage"
	else if string match -r "state" $argv &> /dev/null
		acpi -i|head -n 1|cut -d' ' -f 3
		#upower -i (upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"|head -n 1|cut -c25-
	else if string match -r "percentage|%|charge" $argv &> /dev/null
		acpi -i|head -n 1|cut -d' ' -f 4
		#upower -i (upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"|tail -n 1|cut -c25-
	else if string match -r "time|left|time left" $argv &> /dev/null
		acpi -i|head -n 1|cut -d' ' -f 5
		#upower -i (upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"|sed -n 2p|cut -c25-
	end
end

#python development
function pydev
	cmd nix-shell -p '(callPackage (fetchTarball https://github.com/DavHau/mach-nix/tarball/3.3.0) {}).mach-nix' --run 'mach-nix env ./env -r requirements.txt && nix-shell ./env'
end

#for yt music
function play
	yt -l -m $argv
end

#Verbose mv
function mvv
	mv $argv | progress -m
end

#Verbose cp
function cpv
	cp -r $argv | progress -m
end

# check if vimp-pad dir exists if not create
if which nvim &> /dev/null
	if [ ! -d ~/.local/share/nvim/vim-pad ]
		mkdir ~/.local/share/nvim/vim-pad
	end
end

function fish_greeting
	pgrep startx &> /dev/null
	if test "$status" = "1"; and who -q | grep -e "users=1" &>/dev/null
		clear;echo "Starting your Xserver";
		startx &> /dev/null
		clear;echo "Xserver killed successfully!"
	end
end

function i
	if [ $argv[1] = "-u" ]
		echo "Channel: NIXPKGS" && nix-env -iA nixpkgs.$argv[2]
	else
		echo "Channel: NIXOS" && nix-env -iA nixos.$argv; or echo "Channel: NIXPKGS" && nix-env -iA nixpkgs.$argv
	end
end

function x
	if [ -d $argv ]; count $argv > /dev/null
		rm -rf $argv
	else
		rm $argv
	end
end

function update
	nix-channel --update nixpkgs
	nix-env -u '*'
end

function get
	if [ -z $argv ]
		echo "You do need to pass a link to download !"
	else if echo $argv | grep .github.com &> /dev/null
		git clone $argv;
	else if string match -r ".jpg|.png|.svg|.mp3|.mp4|.zip|.tar|.gz" $argv &> /dev/null
		axel -n 10 $argv #this makes 10 connections, thus speeds the download by 10x the general connection
	else
		wget -r –level=0 -E –ignore-length -x -k -p -erobots=off -np -N "$argv" and echo "Fetched $argv" or echo "Couldn't fetch !"
	end
end

function bind_bang
	switch (commandline -t)[-1]
			case "!"
				commandline -t $history[1]; commandline -f repaint
			case "*"
				commandline -i !
	end
end

function c
	if [ -z $argv ]
		cd ..
	else if [ -e $argv ]
		set filename (echo $argv | cut -d/ -f3)
		cd (string replace $filename '' $argv)
	else
		cd $argv
	end
end

#broken
function cdd
	if test -d $argv
		cd $argv;
	else
		read -p "$argv" "doesn't exist create " ans
		if [ "$ans" = "" ]
			mkdir -p $argv;
			cd $argv;
		end
	end
end

function bind_dollar
	switch (commandline -t)[-1]
		case "!"
			commandline -t ""
			commandline -f history-token-search-backward
		case "*"
			commandline -i '$'
	end
end

function fish_user_key_bindings
	bind ! bind_bang
	bind '$' bind_dollar
end

# https://superuser.com/questions/719531/what-is-the-equivalent-of-bashs-and-in-the-fish-shell

alias d "cd ~/dev"
alias e $EDITOR

if uname -a | grep NixOS &> /dev/null
	alias r "nix-env --uninstall"
	alias q "nix-env -q"
	alias n "nvidia-offload"
else if man yay
	alias s "yay -Ss"
	alias i "yay -Sy"
	alias r "yay -R"
end

#some git alias
alias gi 'git init;git branch -M main'
alias gc 'git commit'
alias gb 'git branch'
alias gr 'git remote'
alias gl 'git log'
alias gd 'git diff'
alias gs 'git status'
alias gck 'git checkout'
alias gx 'git reset --hard'
alias gname 'git branch -M main'

alias check 'cmd nix-shell -I nixpkgs=/home/creator54/nixpkgs -p'
alias l 'ls -sLShA'
alias fix-headphones 'alsactl restore' #https://github.com/NixOS/nixpkgs/issues/34460
alias usb 'cd /run/media/creator54/'
alias clip "xclip -sel clip"
alias stream "cvlc --fullscreen --aspect-ratio 16:9 --loop"
alias size "gdu"
alias keys "screenkey --no-systray -t 0.4"
alias man batman
alias headset "bluetoothctl connect 20:20:10:21:A4:8C"
alias usage "baobab"
alias ftp "ncftp"
alias gallery "gthumb"
alias calc "eva"
alias clipboard "copyq clipboard"
alias ufetch ".//.config/fish/scripts/ufetch"
alias lectures "cd /run/mount/data1/Lectures/Study"
alias ytdl "youtube-dl"
alias sys "cd /etc/nixos"
alias poweshell "pash"
alias pdfviewer "okular"
alias copy "rsync --info=progress2 -auvz"
alias fget "wget -r –level=0 -E –ignore-length -x -k -p -erobots=off -np -N"
alias view_pic "kitty +kitten icat" #for viewing images in kitty
alias torrent "/o.webtorrent.WebTorrent"

#for stuff inside this dir
set dir '~/.config/fish/scripts'

for i in extract_frame ralias reduce rpattern yt ytpart anime wall traffic
	if test $i="yt"; or test $i="traffic"
		alias $i "$dir/$i" | sh
	else
		alias $i "$dir/$i"
	end
end

alias minexmr "xmrig -o pool.minexmr.com:4444 -k --coin monero -a rx/0 --randomx-mode=fast -u 47yKDNQ3bcggyHwp2GrTCV9QdMEP8VzqQak1h9fyvhhRCzfQXdkdonrdUVA4h2SP1QLQX68qmVKKjjDYweng1TAL1gKGS2m"
alias hashvault "xmrig -o pool.hashvault.pro:80 -k --coin monero -a rx/0 --randomx-mode=fast -u 47yKDNQ3bcggyHwp2GrTCV9QdMEP8VzqQak1h9fyvhhRCzfQXdkdonrdUVA4h2SP1QLQX68qmVKKjjDYweng1TAL1gKGS2m"

#doge
alias doge "xmrig -o rx.unmineable.com:3333 -a rx -k -u DOGE:DHzDUHACdrc5j6SM6bSsaWsvrPimFKg8Er.DOGEE#vejs-jzsz"
