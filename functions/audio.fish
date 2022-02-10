function audio
  if [ (amixer get Master toggle | xargs | awk '{print $NF}') = "[off]" ]
    printf "婢 %s" (amixer sget Master | awk -F"[][]" '/Left/ { print $2 }'|cut -d'%' -f1 | xargs)
  else
    printf " %s" (amixer sget Master | awk -F"[][]" '/Left/ { print $2 }'|cut -d'%' -f1 | xargs)
  end

  if [ (headset|tail -n 1|cut -d' ' -f2) = "successful" ]
    printf ":%s\n" (bluetooth_battery 20:20:10:21:A4:8C | cut -d' ' -f6)
  end
end
