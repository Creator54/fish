function hs
  switch $argv[1]
    case '-h'
      echo "Usage: "
      echo "-h  : help"
      echo "-c  : current generation"
      echo "-g  : list generations"
      echo "-r  : -r num, goes back num generations"
    case '-c'
      #cmd "home-manager generations | head -n 1 | tail -n 1"
      home-manager generations | head -n 1 | tail -n 1
    case '-g'
      cmd home-manager generations | bat
    case '-r'
      switch $argv[2]
        case ''
          set argv[2] 2
      end
      set gobackto (home-manager generations | head -n (math $argv[2]+1) |tail -n 1)
      echo "Reverting to Generation:" (echo $gobackto|cut -d' ' -f5)
      cmd (echo $gobackto|cut -d' ' -f7)/activate
    case '*'
      cmd home-manager switch
  end
end
