function c
  if [ -z $argv ]
    cd ..
  else if [ -d $argv ]
    cd $argv
  else if [ -e $argv ]
    set filename (echo $argv | cut -d/ -f3)
    cd (string replace $filename '' $argv)
  else if string match -qr '^[0-9]+$' $argv
    if [ $argv = "1" ] #browsing through /nix/store sometimes doesnt work so workaround for now
      cd ..
    else
      set dir_count (pwd | grep -o "/" | wc -l)
      set go_back (math $dir_count - $argv + 2)
      cd (pwd | awk -F (pwd | cut -d'/' -f$go_back) '{print $1}')
    end
  else
    echo "Directory doesn't exit !"
    read -P "Press enter to create ! " ans #fish use P, bash uses p
    if [ "$ans" = "y" ] || [ "$ans" = "" ]
      mkdir -p $argv;
      cd $argv;
    end
  end
end
