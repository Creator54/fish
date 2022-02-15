function audio
  if [ -z $argv ]
    if [ (amixer get Master toggle | xargs | awk '{print $NF}') = "[off]" ]
      printf "婢 %s" (amixer sget Master | awk -F"[][]" '/Left/ { print $2 }'|cut -d'%' -f1 | xargs)
    else
      printf " %s" (amixer sget Master | awk -F"[][]" '/Left/ { print $2 }'|cut -d'%' -f1 | xargs)
    end

    if test (bluetoothctl info (btid) | grep "Connected: yes")
      printf ":%s\n" (bluetooth_battery (btid) | cut -d' ' -f6)
    end
  else
    echo "Help : "\n
    echo "audio     : shows volume % + battery info if BT device connected"
  end
end
