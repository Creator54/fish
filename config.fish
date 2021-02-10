function fish_greeting
  #fortune -a ascii-art && fortune -a science
end

function i
  if echo $argv | grep nixpkgs. &> /dev/null
    nix-env -iA nixpkgs.$argv
  else
    nix-env -iA nixos.$argv
  end
end

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
