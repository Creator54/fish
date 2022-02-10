#fetch battery left
function battery
  if string match -qr "state" $argv
    acpi -i|head -n 1|cut -d' ' -f 3
  else if string match -qr "percentage|%|charge" $argv
    acpi -i|head -n 1|cut -d' ' -f 4
  else if string match -qr "time|left|time left" $argv
    acpi -i|head -n 1|cut -d' ' -f 5
  else if string match -qr "info" $argv
  if [ (battery state) = "Discharging," ]
    printf " %s\n" (battery %)
    else
      printf "ﮣ %s\n" (battery %)
    end
  else if [ $argv="h" ]
    line
    echo "battery options"
    line
    echo "Options:"
    echo "state:            charging/discharging"
    echo "percentage/%/charge:  shows battery left"
    echo "time/left/time left:  shows remaing time left to charge"
    line
  else
    acpi -i
  end
end
