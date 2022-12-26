function fish_greeting #HANDLE WITH CARE, TEST FUNCTION IN TERMINAL FIRST BEFORE SAVING HERE
  set start_using "sx"
  test (which sx) || set start_using "startx"

  if not [ (pgrep $start_using &>/dev/null; echo $status) -eq 0 ] #checks if
    if [ $start_using = "sx" ]
      sx sh .xinitrc &> /dev/null
    else
      startx &> /dev/null
    end
    exit
  end
end
