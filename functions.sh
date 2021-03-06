
#########################################################################
############################### FUNCTIONS ###############################
#########################################################################

# Easily extract all compressed file types
extract () {
   if [ -f "$1" ] ; then
       case "$1" in
           *.tar.bz2)   tar xvjf  "$1"    ;;
           *.tar.gz)    tar xvzf "$1"     ;;
           *.bz2)       bunzip2  "$1"     ;;
           *.rar)       unrar x  "$1"     ;;
           *.gz)        gunzip  "$1"      ;;
           *.tar)       tar xvf  "$1"     ;;
           *.tbz2)      tar xvjf  "$1"    ;;
           *.tgz)       tar xvzf  "$1"    ;;
           *.zip)       unzip  "$1"       ;;
           *.Z)         uncompress  "$1"  ;;
           *.7z)        7z x  "$1"        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file."
   fi
}

# Define a word using collinsdictionary.com
define() {
  curl -s "http://www.collinsdictionary.com/dictionary/english/$*" | sed -n '/class="def"/p' | awk '{gsub(/.*<span class="def">|<\/span>.*/,"");print}' | sed "s/<[^>]\+>//g"
}

# Epoch time conversion
# can take either timestamp or date as param
# Usage:
#   epoch 140526899
#   epoch 22 june 2014
epoch() {
  TESTREG="[\d{10}]"
  if [[ "$1" =~ $TESTREG ]]; then
    # is epoch
    date -d @$*
  else
    # is date
    if [ $# -gt 0 ]; then
      date +%s --date="$*"
    else
      date +%s
    fi
  fi
}

# Play a beep through the speakers
# e.g.
#    alarm 800 200
alarm() {
  ( \speaker-test --frequency $1 --test sine )&
  pid=$!
  \sleep 0.${2}s
  \kill -9 $pid
}
alias beep='alarm 800 200 > /dev/null'

# Wrap vim in a function that checks write permissions on files
vim() {
  if [[ ! -e "$*" || -w "$*" ]]; then
    /usr/bin/vim "$*"
  else
    sudo /usr/bin/vim "$*"
  fi
}

# Delete a Git branch locally and remotely
gbdel() {
  git branch -D $1 &&
  git push --delete origin $1
}
