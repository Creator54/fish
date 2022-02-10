function e
  switch $argv[1]
  case '-d'
    c $argv[2] && $EDITOR (echo $argv[2]|sed 's/^.*\///')
  case '*'
    $EDITOR $argv
  end
end
