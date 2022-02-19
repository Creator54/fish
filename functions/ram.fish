function ram
  set used (free -h|awk '/^Mem/{print $3}'| grep -Eo '[0-9].[0-9]')
  if echo $used | grep "\." &> /dev/null
    echo (math -s1 "$used*1.073742") GB
  else
    echo (math -s0 "$used*1.048576")MB
  end
end
