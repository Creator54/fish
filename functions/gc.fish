function gc
  if [ -z $argv[1] ]
    git commit
  else if [ $argv[1] = "-d" ]
    if [ -z $argv[2] ]
      git reset HEAD~1
    else
      git reset HEAD~$argv[2]
    end
  else
    git commit $argv
  end
end
