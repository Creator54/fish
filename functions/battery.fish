function battery
  if string match -qr "state" $argv
    acpi -i|head -n 1|cut -d' ' -f 3
  else if string match -qr "percentage|%|charge" $argv
    acpi -i|head -n 1|cut -d' ' -f 4 | cut -d',' -f1
  else if string match -qr "time|left|time left|rem|remaining" $argv
    set rem (acpi -i|head -n 1|cut -d' ' -f5)
    if not [ -z $rem ]
      if [ (echo $rem|cut -d':' -f1) -eq 0 ]
        set rem (acpi -i|head -n 1|cut -d' ' -f5|cut -d':' -f2,3| sed 's/:/m:/;s/$/s/')
        #set rem ($rem|cut -d':' -f2,3| sed 's/:/M:/2;s/$/S/')
      else
        set rem (acpi -i|head -n 1|cut -d' ' -f5|sed 's/:/h:/;s/:/m:/2;s/$/s/')
        #set rem ($rem|sed 's/:/H:/;s/:/M:/2;s/$/S/')
      end
      echo "REM: $rem"
    end
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
