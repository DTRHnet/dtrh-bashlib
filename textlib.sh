#!/bin/bash

# #################################################################################
# DTRH.net
#
# textlib.sh
#
# Library of text related functions including but  not limited to stylizing text, 
# counters, and I/O operations.
#
# Latest Update: Nov 10, 2023
# #################################################################################

# LOGGING (TODO)
shopt -s expand_aliases
_LOG_='.textlib.log' && touch "${_LOG_}"


# #################################################################################
# COLOUR ALIASES
#
alias red="echo 196";     alias lred="echo 1";      alias dred="echo 88"
alias green="echo 2";     alias lgreen="echo 155";  alias dgreen="echo 28"
alias blue="echo 4";      alias lblue="echo 12";    alias dblue="echo 27"
alias yellow="echo 228";  alias lyellow="echo 229"; alias dyellow="echo 226"
alias orange="echo 208";  alias lorange="echo 214"; alias dorange="echo 160"
alias white="echo 255";   alias lgrey="echo 252";   alias dgrey="echo 238"
alias black="echo 0" 

# COLOUR GLOBALS ##################################################################
#
fg=255    # Foreground # White (These can be set to any of the aliases above)
bg=000    # Background # Black "
b=0       # Standard


# #################################################################################
# FUNCTIONS
# #################################################################################

function c() { 
# c() #############################################################################
# 
# Usage: setTextColour $(c red) $(c dgrey) 1 "c returns the colour byte value"    
#        c returns the value via 'echo'.. 
#        It was designed to work with command substitution in mind. This is why the
#        function itself is only onee character long (to save on unnecessary wording)
#
# Example: echo -e '[all aliases]' > /tmp/alias.txt && \
#          sed -i -e 's/;/\n/g' /tmp/alias.txt && sed -i -e 's/=/ /g' /tmp/alias.txt && \
#          awk -F' ' '{print $2}'/tmp/alias.txt && IFS\"\n"
#          while read -r line; do
#             secho $line 0 "Colour Code: $line"
#          done < /tmp/alias.txt
#                            

alias cFg="$1"
alias cBg="$2"

fg=$(cFg)
bg=$(cFg)

[ ! $fg ] && fg=0      # TODO: optimize this, like checking if $2 is
[ ! $bg ] && bg=255    # absent, but $bg has a value. If thats the case it should
                       # not reset the bg colour..

echo -e "$fg $bg"   # To catch in subcommand

}


function secho() { 
# secho() #########################################################################
# "Stylized Echo"
#
# secho COLOUR[alias;byte] BOLD[0-1] "str.."  
#
# Usage:    1.  secho red 0 "str.."  
#           2.  secho 122 1 "str.."
#                                                                                 
# Summary:  Style a string of text. Text colours return to default after after 
#           execution. This function does not set background colours.
#           It resets term colours after displaying the text string
#           
# #################################################################################

  echo -ne $(tput setaf $(c "$1")) 
  if [ $2 = 1 ]; then echo -ne $(tput bold); fi 

  # Reset the terminal. This is intentional.
  echo $3 && echo -ne $(tput sgr0)

}


function setTerm() {
# setTerm() #########################################################################
#
# "Set Terminal"
#
# setTerm FG[ALIAS/BYTE] BG[ALIAS/BYTE] BOLD[0-1]  
#
# Usage:    1.  secho red 0 
#           2.  secho 122 1 
#                                                                                 
# Summary:  Style a string of text. Text colours  do not return to default after  
#           execution. This function does not set background colours.
#           
# #################################################################################

  # Essentially the same as secho, but it won't reset colours, hense the name.
  # Also differs in it will change BG colour if wanted
  echo -ne $(tput setaf $(c "$1")); echo -ne $(tput setab $(c "$2")) 
  if [ $3 = 1 ]; then echo -ne $(tput bold); fi 

}

function setTextColour() {

# setTextColour FG[ALIAS/BYTE] BG[ALIAS/BYTE] BOLD[0-1] TEXT[STRING] 
#
# Usage:    1.  setTextColour lgrey dgrey 1             fg=0-255       
#           2.  setTextColour reset,reset,0             bg=0-255  
#           3.  setTextColour 123,1,1                   b=0-1  
#           4.  setTextColour 20,112,1 "Print some text"          
#                                                                                   
# Summary:  Set  terminal text foreground and background respectively 
#           via 256-bit color or by alias. Call "reset" to reset terminal colours.
#           $2 can optionally contain a string to display after changes are made
#           
# #################################################################################

  local bflag=0
  fg=$1
  bg=$2
  b=$3

  if [[ ! $b = 1 || ! $b = 0 ]]; then b=0; fi  

  if [[ $fg =~ ^[[:digit:]] ]]; then   
    if [[ $fg -gt 255 || $fg -lt 0 ]]; then
      echo -ne "Warning - Value must be valid alias or numerical value between 0 and 255." 1>&2 
      echo -en $(tput setaf sgr0)
      bflag=1
    fi
  fi  
  
  if [[ $bg =~ ^[[:digit:]] ]]; then   
    if [[ $bg -gt 255 || $bg -lt 0 ]]; then
     echo -ne "Warning - Value must be valid alias or numerical value between 0 and 255." 1>&2  
     echo -ne $(tput setab sgr0)
     bflag=1
    fi
  fi   

  if [ bflag = 0]; then setTerm $fg $bg $b; fi  

}
