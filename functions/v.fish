function v
  switch $argv[1]
    case '-*' ''
      switch $argv[1]
        case '-p'
          $PAGER $argv
        case '*'
          echo "Usage: "
          echo "v *.jpg/png/svg                   : opens in sxiv,mark to delete !"
          echo "v *.mp4/mkv/mp3/opus/webm/gif     : opens in mpv"
          echo "v *.pdf                           : opens in zathura"
          echo "v *.iso                           : path copied to clipboard"
          echo "v *.md                            : preview using glow and bat "
          echo "v *.v                             : passes to the V lang Compiler "
          echo "v repl                            : V lang repl "
          echo "v run *.v                         : run the v program "
          echo "v dir/                            : cd dir/"
          echo "v http/https://*                  : proceeds as get function"
          echo "v -p                              : force bat preview"
          echo "v -h                              : help"
      end
    case '*'
      if [ -d "$argv" ]
        if string match -qr "photo|Photo|Screenshot|screenshot|Gallery|gallery|DCIM|pics|Pics|Pictures|pictures|wall|Wall" $argv
          rm -rf (sxiv -o -t $argv)
        else
          cd $argv
        end
      else if string match -qr ".jpg|.png|.svg" $argv
        test -f $argv && rm -rf (sxiv -o $argv) && commandline -f repaint #first check if image exists
      else if string match -qr "http|https" $argv
        get $argv
      else if string match -q "*.pdf" $argv
        zathura $argv &> /dev/null
      else if string match -q "*.iso" $argv
        echo "Copied PATH=$argv to clipboard"
        echo $argv | clip
      else if string match -qr ".md" $argv[1]
        glow $argv -p $PAGER 2>/dev/null #hide bat errors
      else if string match -qr ".v|repl|run|install|.mp4|.mkv|.mp3|.opus|.webm|.gif" $argv #has issues anyfile containing v falls here
        if echo $argv | grep ".v\|run\|repl\|install" >/dev/null;
          bash v $argv
        else if string match -qr ".mp4|.mkv|.mp3|.opus|.webm|gif" $argv
          mpv $argv
        end
      else
        $PAGER $argv
      end
  end
end
