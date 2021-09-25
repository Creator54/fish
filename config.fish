set -gx TERM kitty
set -gx TERMINAL kitty
set -gx EDITOR vim
set -gx VISUAL vim
set -gx BROWSER brave
set -gx WALLPAPERS '/home/creator54/wallpapers'
set -gx CPLUS_INCLUDE_PATH /nix/store/s6scq5f4vk7pmxbch63byqw0zhf988j8-libc++-11.1.0/include/c++/v1
set -gx PAGER "bat"
set -gx MANPAGER "bat" 
set -gx NNN_PLUG 'f:finder;o:fzopen;p:preview-tui;d:diffs;t:nmount;v:imgview;g:!git log;'
set -gx NNN_FIFO '/tmp/nnn.fifo'

function cmd
	echo CMD: $argv; echo
	$argv
end

function he
	cmd home-manager edit
end

function hs
	cmd home-manager switch
end

function v
	if string match -r ".jpg|.png|.svg" $argv &> /dev/null
		view_pic $argv
	else if string match -q "*.pdf" $argv
		zathura $argv &> /dev/null
	else
		$PAGER $argv
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
function BATT
	upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep -Po "\\d+"
end

#python development
function pydev
	nix-shell -p '(callPackage (fetchTarball https://github.com/DavHau/mach-nix/tarball/3.3.0) {}).mach-nix' --run 'mach-nix env ./env -r requirements.txt && nix-shell ./env'
end

#for yt music
function play
	yt -m $argv
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
  if ! nix-env -iA nixos.$argv
    nix-env -iA nixpkgs.$argv;
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
  if echo $argv | grep .git &> /dev/null
    git clone $argv;
  else
    wget -r –level=0 -E –ignore-length -x -k -p -erobots=off -np -N "$argv"
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
  alias s "nix search"
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

alias fix-headphones 'alsactl restore' #https://github.com/NixOS/nixpkgs/issues/34460
alias usb 'cd /run/media/creator54/'
alias clip "xclip -sel clip"
alias stream "cvlc --fullscreen --aspect-ratio 16:9 --loop"
alias size "gdu"
alias keys "screenkey --no-systray -t 0.4"
alias man batman
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

#for stuff inside this dir
set dir '~/.config/fish/scripts'

for i in extract_frame ralias reduce rpattern yt ytpart
  if [ $i = "yt" ]
    alias $i "$dir/$i" | sh
  else
    alias $i "$dir/$i | bash"
  end
end

alias minexmr "xmrig -o pool.minexmr.com:4444 -k --coin monero -a rx/0 --randomx-mode=fast -u 47yKDNQ3bcggyHwp2GrTCV9QdMEP8VzqQak1h9fyvhhRCzfQXdkdonrdUVA4h2SP1QLQX68qmVKKjjDYweng1TAL1gKGS2m"
alias hashvault "xmrig -o pool.hashvault.pro:80 -k --coin monero -a rx/0 --randomx-mode=fast -u 47yKDNQ3bcggyHwp2GrTCV9QdMEP8VzqQak1h9fyvhhRCzfQXdkdonrdUVA4h2SP1QLQX68qmVKKjjDYweng1TAL1gKGS2m"

#doge
alias doge "xmrig -o rx.unmineable.com:3333 -a rx -k -u DOGE:DHzDUHACdrc5j6SM6bSsaWsvrPimFKg8Er.DOGEE#vejs-jzsz"
