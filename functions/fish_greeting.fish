function fish_greeting
  set start_using "sx"
  if not which sx &>/dev/null
    set start_using "startx"
  end

  if not [ (pgrep sx &>/dev/null || pgrep startx &>/dev/null; echo $status) -eq 0 ]
    if [ $start_using = "sx" ]
      sx sh .xinitrc &> /dev/null
    else
      startx &> /dev/null
    end
  end
end
