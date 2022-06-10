function ssh-setup
  ssh-keygen -t rsa -b 4096 -C 'hi.creator54@gmail.com'
  eval (ssh-agent -c)
  ssh-add ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub | clip
  echo "Copied SSH Key to Clipboard, now paste it on Github."
end
