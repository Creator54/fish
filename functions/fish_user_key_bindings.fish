function fish_user_key_bindings
  bind ! bind_bang
  bind '$' bind_dollar
  bind '^K' 'e ~/Apps-data/nixpkgs/configs/fish/config.fish'
  #bind '' 'e ~/.config/nixpkgs/configs/fish/config.fish && commandline -f repaint'
  #bind '' 'cd ~/.config/nixpkgs/configs/;commandline -f repaint'
end
