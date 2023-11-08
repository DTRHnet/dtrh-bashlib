#!/bin/bash

# SETTEXTCOLOUR 
#
# Usage:    1.  setTextColour fg,bg,fs                    fg=0-255       
#           2.  setTextColour reset,reset,0               bg=0-255  
#           3.  setTextColour red,yellow,1                fs=0/1  # Bold
#           4.  setTextColour 20,112,1 "Print some text"          
#
#           Aliases: red         blue        white   black      
#                    green       orange      grey    lgrey
#                    yellow      purple      dgrey
#                                                                                   
# Summary:  Set  terminal text foreground and background respectively 
#           via 256-bit color or by alias. Call "reset" to reset terminal colours.
#           $2 can optionally contain a string to display after changes are made
#           
# #################################################################################

function setTextColour() {

  local oPS1="${PS1}"
  local fg="$(echo -e $1 | awk -F',' '{print $1}' ;)"; 
  local bg="$(echo -e $1 | awk -F',' '{print $2}' ;)";
  local fs="$(echo -e $1 | awk -F',' '{print $3}' ;)";
  local tString=$2

  
  local alias red=196; local alias green=46; local alias blue=12
  local alias yellow=226; local alias orange=11; local alias white=255
  local alias lgrey=252; local alias dgrey=242; local alias black=232 

  case "$fg" in
    "")
      fg=$white ;;
    reset) 
      fg=$white ;;
    red)
      fg=$red ;;
    yellow) 
      fg=$yellow ;;
    lgrey)
      fg=$lgrey ;;
    green)
      fg=$green ;;
    orange)
      fg=$orange ;;
    dgrey) 
      fg=$dgrey ;;
    blue)
      fg=$blue ;;
    white)
      fg=$white ;;
    black)
      fg=$black ;;
  esac 

  if [[ $fg -gt 255 || $fg -lt 0 ]]; then
    echo "Warning - Value must be valid alias or numerical value between 0 and 255." 1>&2 /dev/null
  fi 
  if [ $fs = 1 ]; then echo -e "$(tput setaf $fg; tput bold)"; else echo -e "$(tput setaf $fg; tput normal)"; fi 
  
  case $bg in
    "") bg=$black ;;
    reset) 
      bg=$black ;;
    red) 
      bg=$red ;;
    yellow) 
      bg=$yellow ;;
    lgrey)
      bg=$lgrey ;;
    green)
      bg=$green ;;
    orange)
      bg=$orange ;;
    dgrey) 
      bg=$dgrey ;;
    blue)
      bg=$blue ;;
    white)
      bg=$white ;;
    black)
      bg=$black ;;
    #*) 
    #  bg=$black ;;
  esac 

  if [[ $bg -gt 255 || $bg -lt 0 ]]; then
    echo "Warning - Value must be valid alias or numerical value between 0 and 255." 1>&2  
  fi 
  echo -ne "$(tput setab $bg)"
  
  if [ $tString ]; then echo -e "$tString"; fi  
     
}

