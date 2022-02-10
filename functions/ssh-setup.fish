function ssh-setup
  ssh-keygen -t ed25519 -C 'hi.$USER@gmail.com'
  eval (ssh-agent -c)
  ssh-add ~/.ssh/id_ed25519
  cat ~/.ssh/id_ed25519.pub | clip
  echo "Copied SSH Key to Clipboard, now paste it on Github."
end
