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

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end

# https://superuser.com/questions/719531/what-is-the-equivalent-of-bashs-and-in-the-fish-shell

alias d "cd ~/dev"
alias v "$EDITOR"
alias c "cd .."
alias s "nix search"
alias r "nix-env --uninstall"
alias q "nix-env -q"
alias n "nvidia-offload"
alias calc "eva"
alias ufetch ".//.config/fish/scripts/ufetch"
alias lectures "cd /run/mount/data/Lectures"
alias ytdl "youtube-dl"
alias sys "cd /etc/nixos"
alias view_pic "kitty +kitten icat" #for viewing images in kitty

#for stuff inside this dir
set dir '~/.config/fish/scripts'

for i in extract_frame ralias reduce rpattern yt ytpart 
  alias $i "$dir/$i | bash"
end

