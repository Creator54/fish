function push
  if [ (count $argv) -eq 1 ]
    #scp -i ~/.ssh/webserver -rp $argv[1] $SERVER:/home/creator54
    connect_me -n ; rsync -e "ssh -i ~/.ssh/webserver" $argv[1] -aPvz $SERVER:~/
  else
    #scp -i ~/.ssh/webserver -rp $argv[1] $SERVER:/$argv[2] # -r for folders preserve times and modes of the original files and subdirectories
    connect_me -n ; rsync -e "ssh -i ~/.ssh/webserver" $argv[1] -aPvz $SERVER:$argv[2]
  end
end
