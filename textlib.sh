#!/bin/bash

# #################################################################################
# DTRH.net
#
# textlib.sh
#
# Library of text related functions including but  not limited to stylizing text, 
# counters, and I/O operations.
#
# #################################################################################


shopt -s expand_aliases
_LOG_='.textlib.log' && touch "${_LOG_}"


# #################################################################################
# COLOUR ALIASES

alias red="echo 196";     alias lred="echo 1";      alias dred="echo 88"
alias green="echo 2";     alias lgreen="echo 155";  alias dgreen="echo 28"
alias blue="echo 4";      alias lblue="echo 12";    alias dblue="echo 27"
alias yellow="echo 228";  alias lyellow="echo 229"; alias dyellow="echo 226"
alias orange="echo 208";  alias lorange="echo 214"; alias dorange="echo 160"
alias white="echo 255";   alias lgrey="echo 252";   alias dgrey="echo 238"
alias black="echo 0" 

# COLOUR GLOBALS
fg=255    # Foreground
bg=000    # Background
b=0       # Bold


# #################################################################################
# FUNCTIONS

# C : Convert colour alias to appropriate 256 byte pointing to colour
#     c returns in the form of the byte echoing. 
#     It's most easily used via command substitution ie:
#
#     $(c alias)    # Substitute this in place of a byte colour code 
function c() { alias cc="$1" && fg=$(cc); echo -n $fg; }


function secho() { 

# "Stylized Echo"
#
# secho COLOUR[ALIAS/BYTE] BOLD[0-1] "STRING"  
#
# Usage:    1.  secho red 0 "STRING"  
#           2.  secho 122 1 "STRING"
#                                                                                 
# Summary:  Style a string of text. Text colours return to default after after 
#           execution. This function does not set background colours.
#           
# #################################################################################

  echo -ne $(tput setaf $(c "$1")) 
  if [ $2 = 1 ]; then echo -ne $(tput bold); fi 
  echo $3 && echo -ne $(tput sgr0)

}


function setTerm() {

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

  fg=$1
  bg=$2
  b=$3

  if [[ $fg =~ ^[[:digit:]] ]]; then   
    if [[ $fg -gt 255 || $fg -lt 0 ]]; then
      echo -ne "Warning - Value must be valid alias or numerical value between 0 and 255." 1>&2 
      fg=$(c white)
    fi
  fi  
  
  if [[ $bg =~ ^[[:digit:]] ]]; then   
    if [[ $bg -gt 255 || $bg -lt 0 ]]; then
     echo -ne "Warning - Value must be valid alias or numerical value between 0 and 255." 1>&2  
     bg=$(c black)
    fi
  fi   

  if [[ ! $b = 1 || ! $b = 0 ]]; then b=0; fi  
  setTerm $fg $bg $b 

}


