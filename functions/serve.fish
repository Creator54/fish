function serve
  if [ -z $argv[1] ]
    echo "Usage : "\n
    echo "serve file    :   hosts the file on sharedby.creator54.me"
    echo "serve -d file :   removes the file hosted on sharedby.creator54.me"
  else if [ $argv[1] = "-d" ]
    echo "Removing $argv[2] .."
    ssh $NIX -i ~/.ssh/webserver -t "rm -rf ~/website-stuff/sharedby/$argv[2]" && echo "File is removed !"
  else
    set url "http://sharedby.creator54.me/files/$argv"
    push $argv ~/website-stuff/sharedby
    echo "File is shared @ $url" && echo $url | clip
  end
end
