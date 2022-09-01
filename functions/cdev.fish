function cdev
  set -x src (echo (pwd)/$argv) #without -x, i.e export entr won't be able to read the shell vaiable
  if echo $src | grep ".cpp\|.cxx" &>/dev/null
    ls $src | entr -c sh -c 'printf "Output :\n\n" && g++ $src -o temp && ./temp && rm -rf temp'
  else
    ls $src | entr -c sh -c 'printf "Output :\n\n" && gcc $src -o temp && ./temp && rm -rf temp'
  end
end
