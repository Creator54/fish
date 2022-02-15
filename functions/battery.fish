function battery
  switch $argv
    case 'state'
      acpi -i|head -n 1|cut -d' ' -f3 | cut -d',' -f1
    case '%'
      acpi -i|head -n 1|cut -d' ' -f4 | cut -d',' -f1
    case 'rem'
      set rem (acpi -i|head -n 1|cut -d' ' -f5)
      set rem_check (acpi -i|head -n 1|cut -d' ' -f5|cut -d':' -f1)
      if not [ -z $rem ] #only show if not empty
        if [ $rem_check -eq 0 ]
          set rem (echo $rem | cut -d':' -f2,3| sed 's/:/m:/;s/$/s/')
          #set rem ($rem|cut -d':' -f2,3| sed 's/:/M:/2;s/$/S/')
        else if string match -qr '^[0-9]+$' $rem_check #for rem_check !=0 && is not string
          set rem (echo $rem | sed 's/:/h:/;s/:/m:/2;s/$/s/')
          #set rem ($rem|sed 's/:/H:/;s/:/M:/2;s/$/S/')
        end

        if not string match -qr "discharging|Unknown" $rem #discharging/Unknown case occurs for few seconds on connect/disconnect to power
          printf "[%s]" (echo $rem|cut -d':' -f1,2)
        end
      end
    case 'fancy'
      if [ (battery state) = "Discharging" ]
        printf " %s %s\n" (battery %) (battery rem)
      else if [ (battery state) = "Full" ]
        printf "ﮣ %s Full\n" (battery %)
      else
        printf "ﮣ %s %s\n" (battery %) (battery rem)
      end
    case 'info'
      acpi -i
    case '*'
      echo "Usage: "
      echo
      echo "%       :  battery left"
      echo "rem     :  time left to charge/discharge"
      echo "info    :  battery info verbose"
      echo "fancy   :  fancy battery info"
      echo "state   :  charging/discharging"
  end
end
