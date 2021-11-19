set -gx TERM kitty
set -gx TERMINAL $TERM
set -gx EDITOR vim
set -gx VISUAL vim
set -gx BROWSER brave
set -gx WALLPAPERS '/home/creator54/wallpapers'
set -gx PAGER "bat"
set -gx NNN_PLUG 'f:finder;o:fzopen;p:preview-tui;d:diffs;t:nmount;v:imgview;g:!git log;'
set -gx NNN_FIFO '/tmp/nnn.fifo'

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
	switch $argv[1]
		case ''
			cmd home-manager switch
		case '-g'
			cmd home-manager generations | bat
		case '-r'
			set gobackto (home-manager generations | head -n $argv[2]|tail -n 1)
			if [ -z $argv[2] ]
				set argv[2] 1
			end
			echo "Reverting to Generation:" (echo $gobackto|cut -d' ' -f5)
			cmd (echo $rev|cut -d' ' -f7)/activate
	end
end

function line
	for i in (seq 1 $COLUMNS)
		tput smacs
		printf "%s" 's'
		tput rmacs
	end
	printf "\n"
end

# Add this to you config.fish or equivalent.
# Fish don't support recursive calls so use f function
function f
  fff $argv
  set -q XDG_CACHE_HOME; or set XDG_CACHE_HOME $HOME/.cache
  cd (cat $XDG_CACHE_HOME/fff/.fff_d)
end


function yt
	if echo $argv[1] | grep '-' &> /dev/null
		switch $argv[1]
			case '-y'
				ytfzf $argv[2] $argv[3]
			case '-d'
				echo 'yt-dlp -f 251+247 $argv[2]' > yt-resume
				yt-dlp -f 251+247 $argv[2] && rm -rf yt-resume #thus if this file exists shell knows download incomplete thus asks to complete
			case '-F'
				yt-dlp -F $argv[2]
			case '-f'
				yt-dlp -f $argv[2] $argv[3]
			case '*'
				echo "Usage: "
				echo "yt <link> 	 			: browse via ytfzf script"
				echo "yt -y <flag> <link> 			: browse via ytfzf script with flags"
				echo "yt -d <link> 				: start video download default quality "
				echo "yt -f <link> 				: use specified format to download"
				echo "yt -F <link> 				: show available formats"
			end
		else
			ytfzf $argv
		end
end

function blur
	if [ -z $argv[1] ]
		echo "Usage: blur 10 screenshot.jpg #10% blur"
	else
		convert -scale (math 100 - $argv[1])% -scale 1000% $argv[2] blurred-$argv[2];
		v blurred-$argv[2];
	end
end

function cpu
  set cpu_val (grep -o "^[^ ]*" /proc/loadavg)
  set core_0 (printf "%d" (sensors|grep 'Core 0:' | awk '{ print $3}') 2>/dev/null)
  set core_1 (printf "%d" (sensors|grep 'Core 1:' | awk '{ print $3}') 2>/dev/null)
  set core_2 (printf "%d" (sensors|grep 'Core 2:' | awk '{ print $3}') 2>/dev/null)
  set core_3 (printf "%d" (sensors|grep 'Core 3:' | awk '{ print $3}') 2>/dev/null)
  set temp (math -s0 "($core_0+$core_1+$core_2+$core_3)"/4)
  echo "$cpu_val/$temp°C"
end

function fgit
	set dirname (echo $argv| cut -d'/' -f5| cut -d'.' -f1)
	if [ -z $argv ]
		echo "usage: fgit https://github.com/repo_owner/repo_name"
	else
		git clone --filter=blob:none --no-checkout --depth 1 --sparse $argv &> /dev/null 
		cd $dirname
		git sparse-checkout init --cone
		read -P "get $dirname/" subdir
		git sparse-checkout add $subdir
		git checkout
	end
end

function audio
  if [ (amixer get Master toggle | xargs | awk '{print $NF}') = "[off]" ]
    printf "婢 %s" (amixer sget Master | awk -F"[][]" '/Left/ { print $2 }'|cut -d'%' -f1 | xargs)
  else
    printf " %s" (amixer sget Master | awk -F"[][]" '/Left/ { print $2 }'|cut -d'%' -f1 | xargs)
  end

  if [ (headset|tail -n 1|cut -d' ' -f2) = "successful" ]
    printf ":%s\n" (bluetooth_battery 20:20:10:21:A4:8C | cut -d' ' -f6)
  end
end

function record
	set name (echo (date '+%a-%F')-$count)
	#	if string match -qr 'vcam' $argv
	#		cmd ffmpeg -f x11grab -i $DISPLAY.0 -i /dev/video0
	#		~/Screenrecords/$name+cam.mkv needs fixes
	if string match -qr 'v|video|no audio' $argv
		cmd ffmpeg -f x11grab -i $DISPLAY.0 ~/Screenrecords/$name.mkv
	else if string match -qr 'cam|camera' $argv
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
	else if string match -qr ".jpg|.png|.svg" $argv
		rm -rf (sxiv -o $argv) && commandline -f repaint
	else if string match -qr ".mp4|.mkv|.mp3|.opus|.webm" $argv
		mpv $argv
	else if string match -qr "http|https" $argv
		get $argv
	else if string match -q "*.pdf" $argv
		zathura $argv &> /dev/null
	else if string match -q "*.iso" $argv
		echo "Copied PATH=$argv to clipboard"
		echo $argv | clip
	else if string match -qr ".md" $argv
		glow $argv -p $PAGER
	else
		$PAGER $argv
	end
end

function s
	switch $argv[1]
		case '-*'
			switch $argv[1]
				case '-y'
					yt $argv[2]
				case '-s'
					play $argv[2]
				case '-a'
					if string match -qr '^[0-9]+$' $argv[2] #usage: s -a 360 $query
						anime -q $argv[2] $argv[3]
					else
						anime $argv[2]
					end
				case '-v'
					mpv (fzf -q "$argv[2]") > /dev/null
				case '-l'
					printf "From nix-locate:\n\n"
					nix-locate $argv[2]; or echo "Seems to be 1st time .." && echo "Running nix-index first !" && line && nix-index && nix-locate $argv[2]
				case '-f'
					set file (fzf -q "$argv[2]")
					echo $file | clip
					v $file
				case '-w'
					switch $argv[2]
						case '!g'
							echo "From the WEB 2.0:"
							echo "Google results:"
							googler $argv[3]
						case '!*'
							echo "Searching $argv[3] @"(echo $argv[2]|cut -d! -f2 )
							ddgr $argv[2] $argv[3] | head -n 1
						case '*'
							echo "From the WEB 2.0:"
							echo "Duckduckgo results:"
							ddgr $argv[2]
					end
				case '-h'
					printf "What this function can do ?\n\n"
					echo "s query 		: does nix-search, nix-locate if nix-search fails"
					echo "s -v query 		: does video search,plays via mpv"
					echo "s -l query 		: does nix-locate, find libs"
					echo "s -a query 		: does anime search"
					echo "s -a 360/480/*** query 	: does anime search with quality"
					echo "s -s query 		: does yt-audio search"
					echo "s -y query 		: does yt-video search"
					echo "s -f query 		: does a file search, opens as per function v and copies path to clipboard"
					echo "s -w query 		: does WEB search(ddg results)"
					echo "s -w !g query 		: does WEB search(google results)"
					echo "s -w !domain 		: does web search on domain specified(e.g !google hello: searches hello on google.com), opens on browser"
					printf "s -h			: help menu\n\n"
				case '*'
					printf "flag not found !\nCheckout 's -h' for all available options .\n"
			end
		case '*'
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
	if string match -qr 'github.io' $argv
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
	if string match -qr "state" $argv
		acpi -i|head -n 1|cut -d' ' -f 3
	else if string match -qr "percentage|%|charge" $argv
		acpi -i|head -n 1|cut -d' ' -f 4
	else if string match -qr "time|left|time left" $argv
		acpi -i|head -n 1|cut -d' ' -f 5
	else if string match -qr "info" $argv
		if [ (battery state) = "Discharging," ]
			printf " %s\n" (battery %)
		else
			printf "ﮣ %s\n" (battery %)
		end
	else if [ $argv="h" ]
		line
		echo "battery options"
		line
		echo "Options:"
		echo "state: 			charging/discharging"
		echo "percentage/%/charge: 	shows battery left"
		echo "time/left/time left: 	shows remaing time left to charge"
		line
	else
		acpi -i
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
		startx &> /dev/null
	end
end

function i
	if [ $argv[1] = "-l" ];or [ $argv[1] = "-latest" ]
		echo "Channel: Creator54/nixpkgs"
		nix-env -f /home/creator54/nixpkgs -iA $argv[2]
	else if [ $argv[1] = "-u" ];or [ $argv[1] = "-update" ]
		echo "Channel: NIXPKGS" && nix-env -iA nixpkgs.$argv[2]
	else
		echo "Channel: NIXOS" && nix-env -iA nixos.$argv; or echo "Channel: NIXPKGS" && nix-env -iA nixpkgs.$argv; or echo "Channel: Creator54/nixpkgs" && nix-env -f /home/creator54/nixpkgs -iA $argv
	end
end

function update
	nix-channel --update nixpkgs
	nix-env -u '*'
end

function get
	if [ -z $argv ]
		echo "You do need to pass a link to download !"
	else if string match -qr "github.com" $argv
		git clone $argv && cd  (echo $argv |cut -d'/' -f5)
	else if string match -qr ".mp3|.mp4|.mkv|.zip|.tar|.gz" $argv
		axel -n 10 $argv #this makes 10 connections, thus speeds the download by 10x the general connection
	else
		wget -r –level=0 -E –ignore-length -x -k -p -erobots=off -np -N "$argv" and echo "Fetched $argv" or echo "Couldn't fetch !"
	end
end

function c
	if [ -z $argv ]
		cd ..
	else if [ -d $argv ]
		cd $argv
	else if [ -e $argv ]
		set filename (echo $argv | cut -d/ -f3)
		cd (string replace $filename '' $argv)
	else if string match -qr '^[0-9]+$' $argv
		if [ $argv = "1" ] #browsing through /nix/store sometimes doesnt work so workaround for now
			cd ..
		else
			set dir_count (pwd | grep -o "/" | wc -l)
			set go_back (math $dir_count - $argv + 2)
			cd (pwd | awk -F (pwd | cut -d'/' -f$go_back) '{print $1}')
		end
	else
		echo "Directory doesn't exit !"
		read -P "Press enter to create ! " ans #fish use P, bash uses p
		if [ "$ans" = "y" ] || [ "$ans" = "" ]
			mkdir -p $argv;
			cd $argv;
		end
	end
end

function e
	switch $argv[1]
		case '-d'
			c $argv[2] && $EDITOR (echo $argv[2]|sed 's/^.*\///')
		case '*'
			$EDITOR $argv
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

function bind_bang
	switch (commandline -t)[-1]
			case "!"
				commandline -t $history[1]; commandline -f repaint
			case "*"
				commandline -i !
	end
end

function fish_user_key_bindings
	bind ! bind_bang
	bind '$' bind_dollar
	bind '' 'sudo rfkill unblock all; sudo systemctl restart bluetooth && commandline -f repaint' 
	#bind '' 'e ~/.config/nixpkgs/configs/fish/config.fish && commandline -f repaint'
	#bind '' 'cd ~/.config/nixpkgs/configs/;commandline -f repaint'
end

# https://superuser.com/questions/719531/what-is-the-equivalent-of-bashs-and-in-the-fish-shell

if uname -a | grep NixOS &> /dev/null
	alias r "nix-env --uninstall"
	alias q "nix-env -q"
	alias n "which nvidia-offload&> /dev/null && nvidia-offload; or nnn"
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

alias apps "~/Apps-data/apps"
alias dmenu "/home/creator54/dmenu/dmenu -y 8 -p ' Packages ' -nf '#7EC7A2' -sb '#262626'"
alias dwmblocks "~/Apps-data/nixpkgs/wm/wm-configs/dwm/dwmblocks/dwmblocks"
alias check 'cmd nix-shell -I nixpkgs=/home/creator54/nixpkgs -p'
alias d "cd ~/dev"
alias x "rm -rf $argv"
alias l 'ls -sLShA'
alias fix-headphones 'alsactl restore' #https://github.com/NixOS/nixpkgs/issues/34460
alias usb 'cd /run/media/creator54/'
alias clip "xclip -sel clip"
alias stream "cvlc --fullscreen --aspect-ratio 16:9 --loop"
alias size "gdu"
alias keys "screenkey --no-systray -t 0.4"
alias man batman
alias fzf "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias headset "bluetoothctl connect 20:20:10:21:A4:8C"
alias usage "baobab"
alias ftp "ncftp"
alias gallery "gthumb"
alias calc "eva"
alias clipboard "copyq clipboard"
alias lectures "cd /run/mount/data1/Lectures/Study"
alias sys "cd /etc/nixos"
alias poweshell "pash"
alias pdfviewer "okular"
alias copy "rsync --info=progress2 -auvz"
alias fget "wget -r –level=0 -E –ignore-length -x -k -p -erobots=off -np -N"
alias view_pic "kitty +kitten icat" #for viewing images in kitty
alias torrent "io.webtorrent.WebTorrent"

#for stuff inside this dir
set dir '~/.config/fish/scripts'

for i in (ls /home/creator54/.config/fish/scripts/)
		alias $i "$dir/$i"
end

alias minexmr "xmrig -o pool.minexmr.com:4444 -k --coin monero -a rx/0 --randomx-mode=fast -u 47yKDNQ3bcggyHwp2GrTCV9QdMEP8VzqQak1h9fyvhhRCzfQXdkdonrdUVA4h2SP1QLQX68qmVKKjjDYweng1TAL1gKGS2m"
alias hashvault "xmrig -o pool.hashvault.pro:80 -k --coin monero -a rx/0 --randomx-mode=fast -u 47yKDNQ3bcggyHwp2GrTCV9QdMEP8VzqQak1h9fyvhhRCzfQXdkdonrdUVA4h2SP1QLQX68qmVKKjjDYweng1TAL1gKGS2m"

#doge
alias doge "xmrig -o rx.unmineable.com:3333 -a rx -k -u DOGE:DHzDUHACdrc5j6SM6bSsaWsvrPimFKg8Er.DOGEE#vejs-jzsz"
