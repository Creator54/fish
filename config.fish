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

alias dd "cd ~/dev"
alias v "$EDITOR"
alias c "cd .."
alias s "nix search"
alias r "nix-env --uninstall"
alias q "nix-env -q"
alias n "nvidia-offload"
alias calc "eva"
alias lectures "cd /run/mount/data/Lectures"
alias ytdl "youtube-dl"
alias vv "cd /etc/nixos"
alias view_pic "kitty +kitten icat" #for viewing images in kitty
alias extract_frame "./.scripts/extract_frame"
alias ralias "./scripts/ralias"
alias reduce "./scripts/reduce"
alias rpattern "./scripts/rpattern"
alias yt "./scripts/yt"
alias ytpart "./scripts/ytpart"
