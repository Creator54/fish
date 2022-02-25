#python development
function pydev
  cmd nix-shell -p '(callPackage (fetchTarball https://github.com/DavHau/mach-nix/tarball/3.4.0) {}).mach-nix' --run 'mach-nix env ./env -r requirements.txt && nix-shell ./env'
end
