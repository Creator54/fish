set -gx EDITOR vim
set -gx PAGER "nvim +Man!"
set -gx MANPAGER "nvim +Man!"

function fish_greeting
end

function i
  if ! nix-env -iA nixos.$argv
    nix-env -iA nixpkgs.$argv;
  end
end

function x
  if [ -d $argv ]
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

#broken
function cdd
  if test -d $argv
    cd $argv;
  else
    read -p "$argv" "doesn't exist create " ans
		if [ "$ans" = "" ]
      mkdir $argv;
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
alias c "cd .."
alias v $PAGER

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
