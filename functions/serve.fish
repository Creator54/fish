function serve
  if [ -z $argv ]
    echo "Usage : "\n
    echo "serve file    :   hosts the file on sharedby.creator54.me"
  else
    set url "http://sharedby.creator54.me/$argv"
    push $argv ~/website-stuff/sharedby
    ssh $NIX -i ~/.ssh/webserver -t "sudo nixos-rebuild switch" && echo "File is shared @ $url" && echo $url | clip
  end
end
