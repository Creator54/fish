function share
  if [ -z $argv ]
    echo "Usage:\n share image/file/mirror size< 500MiB\n Check http://0x0.st/"
  else
    if string match -qr "http|https" $argv
      curl -F'url='$argv https://0x0.st | clip
    else
      curl -F'file=@'$argv http://0x0.st | clip
    end
    echo "Link copied to clipboard !"
  end
end
