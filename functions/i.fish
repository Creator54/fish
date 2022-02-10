function i
  if [ $argv[1] = "-l" ];or [ $argv[1] = "-latest" ]
    echo "Channel: Creator54/nixpkgs"
    nix-env -f /home/$USER/nixpkgs -iA $argv[2]
  else if [ $argv[1] = "-u" ];or [ $argv[1] = "-update" ]
    echo "Channel: NIXPKGS" && nix-env -iA nixpkgs.$argv[2]
  else
    echo "Channel: NIXOS" && nix-env -iA nixos.$argv; or echo "Channel: NIXPKGS" && nix-env -iA nixpkgs.$argv; or echo "Channel: Creator54/nixpkgs" && nix-env -f /ho
me/$USER/nixpkgs -iA $argv
  end
end
