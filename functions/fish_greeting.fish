function fish_greeting
  pgrep startx &> /dev/null
  if test "$status" = "1"; and who -q | grep -e "users=1" &>/dev/null
    startx &> /dev/null
  end
end
