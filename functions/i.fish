function i
  switch $argv[1]
    case -l -latest --latest latest
      echo "Channel: Creator54/nixpkgs"
      nix-env -f /home/$USER/nixpkgs -iA $argv[2]
    case -u -update --update update
      echo "Channel: NIXPKGS" && nix-env -iA nixpkgs.$argv[2]
    case '*'
      echo "Channel: Creator54/nixpkgs" && nix-env -f /home/$USER/nixpkgs -iA $argv; or echo "Channel: NIXPKGS" && nix-env -iA nixpkgs.$argv; or echo "Channel: NIXOS" && nix-env -iA nixos.$argv
    end
end
