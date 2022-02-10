function fgit
  set dirname (echo $argv| cut -d'/' -f5| cut -d'.' -f1)
  if [ -z $argv ]
    echo "usage: fgit https://github.com/repo_owner/repo_name"
  else
    git clone --filter=blob:none --no-checkout --depth 1 --sparse $argv &> /dev/null
    cd $dirname
    git sparse-checkout init --cone
    read -P "get $dirname/" subdir
    git sparse-checkout add $subdir
    git checkout
  end
end
