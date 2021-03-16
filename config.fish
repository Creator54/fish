function fish_greeting
  fortune -a ascii-art && fortune -a science
end

function i
  if echo $argv | grep nixpkgs. &> /dev/null
    nix-env -iA nixpkgs.$argv
  else
    nix-env -iA nixos.$argv
  end
end

function x
  if [ -d $argv ]
    rm -rf $argv
  else
    rm $argv
  end
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

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

#docker containers

function kali
  sudo docker start cool_wozniak
  sudo docker exec -it cool_wozniak bash
end

function ubuntu
  sudo docker start infallible_beaver
  sudo docker exec -it infallible_beaver bash
end 

function archlinux  #cant use archlinux:latest bcoz of alpm/ glibc issue use logankoester/archlinux
  sudo docker start inspiring_shamir
  sudo docker exec -it inspiring_shamir bash
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end

# https://superuser.com/questions/719531/what-is-the-equivalent-of-bashs-and-in-the-fish-shell

alias d "cd ~/dev"
alias v "$EDITOR"
alias c "cd .."
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
alias calc "eva"
alias ufetch ".//.config/fish/scripts/ufetch"
alias lectures "cd /run/mount/data1/Lectures/Study"
alias ytdl "youtube-dl"
alias sys "cd /etc/nixos"
alias poweshell "pash"
alias copy "rsync --info=progress2 -auvz"
alias fget "wget -r –level=0 -E –ignore-length -x -k -p -erobots=off -np -N"
alias view_pic "kitty +kitten icat" #for viewing images in kitty

#for stuff inside this dir
set dir '~/.config/fish/scripts'

for i in extract_frame ralias reduce rpattern yt ytpart 
  alias $i "$dir/$i | bash"
end

