
function s
  switch $argv[1]
    case '-*'
      switch $argv[1]
        case '-y'
          yt $argv[2]
        case '-s'
          play $argv[2]
        case '-a'
          if string match -qr '^[0-9]+$' $argv[2] #usage: s -a 360 $query
            anime -q $argv[2] $argv[3]
          else
            anime $argv[2]
          end
        case '-v'
          mpv (fzf -q "$argv[2]") > /dev/null
        case '-l'
          printf "From nix-locate:\n\n"
          nix-locate $argv[2]; or echo "Seems to be 1st time .." && echo "Running nix-index first !" && line && nix-index && nix-locate $argv[2]
        case '-f'
          set file (fzf -q "$argv[2]")
          echo $file | clip
          v $file
        case '-w'
          switch $argv[2]
            case '!g'
              echo "From the WEB 2.0:"
              echo "Google results:"
              googler $argv[3]
            case '!*'
              echo "Searching $argv[3] @"(echo $argv[2]|cut -d! -f2 )
              ddgr $argv[2] $argv[3] | head -n 1
            case '*'
              echo "From the WEB 2.0:"
              echo "Duckduckgo results:"
              ddgr $argv[2]
          end
        case '-h'
          printf "What this function can do ?\n\n"
          echo "s query         : does nix-search, nix-locate if nix-search fails"
          echo "s -v query      : does video search,plays via mpv"
          echo "s -l query      : does nix-locate, find libs"
          echo "s -a query      : does anime search"
          echo "s -a 360/480/*** query  : does anime search with quality"
          echo "s -s query      : does yt-audio search"
          echo "s -y query      : does yt-video search"
          echo "s -f query      : does a file search, opens as per function v and copies path to clipboard"
          echo "s -w query      : does WEB search(ddg results)"
          echo "s -w !g query       : does WEB search(google results)"
          echo "s -w !domain        : does web search on domain specified(e.g !google hello: searches hello on google.com), opens on browser"
          printf "s -h          : help menu\n\n"
        case '*'
          printf "flag not found !\nCheckout 's -h' for all available options .\n"
      end
    case '*'
      printf "From nix search:\n\n" && nix search $argv; or line && printf "\nFrom nix-locate:\n\n" && nix-locate bin/$argv
  end
end
