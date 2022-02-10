function pull
  if [ (count $argv) -eq 1 ]
    connect_me -n; rsync -e "ssh -i ~/.ssh/webserver" -chavzP $SERVER:~/$argv[1] .
    #scp -i ~/.ssh/webserver -rp $SERVER:/home/creator54/$argv[1] .
  else
    connect_me -n ; rsync -e "ssh -i ~/.ssh/webserver" -chavzP $SERVER:~/$argv[1] $argv[2]
    #scp -i ~/.ssh/webserver -rp $SERVER:/home/creator54/$argv[1] $argv[2]
  end
end
