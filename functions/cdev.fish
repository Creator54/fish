function cdev
  if not set -q argv[1]
    set WORKDIR /tmp/CP
    mkdir -p $WORKDIR
    touch $WORKDIR/code.cpp $WORKDIR/inputs $WORKDIR/output
    printf '#include<bits/stdc++.h>\nusing namespace std;\n\nint main(){\n  cout<<"Hello World";\n}' > $WORKDIR/code.cpp
    kitty --session (cd (dirname (status -f)); and pwd)/cp_session
    rm -rf $WORKDIR
  else
    set -x src (echo (pwd)/$argv) #without -x, i.e export entr won't be able to read the shell vaiable
    if echo $src | grep ".cpp\|.cxx" &>/dev/null
      ls $src | entr -c sh -c 'printf "Output :\n\n" && g++ $src -o temp && ./temp && rm -rf temp'
    else
      ls $src | entr -c sh -c 'printf "Output :\n\n" && gcc $src -o temp && ./temp && rm -rf temp'
    end
  end
end
