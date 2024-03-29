#!/usr/bin/env bash

MAIN_BRANCH="main"
DEFAULT_USER_BRANCH="custom"

COLOR_SUCCESS='\033[1;32m'
COLOR_ERROR='\033[1;31m'
COLOR_PROMPT='\033[1;36m'
COLOR_INFO='\033[0;37m'
COLOR_TITLE='\033[0;33m'
COLOR_NO='\033[0m'
BIBERCONF_TITLE="${COLOR_TITLE}=========\nBiberconf\n=========${COLOR_NO}"

echo_success() {
  echo
  echo -e "${BIBERCONF_TITLE}${COLOR_SUCCESS}"
  echo -e "$1"
  shift
  echo -en "${COLOR_INFO}"
  for line in "$@"; do
    echo -e "$line"
  done
  echo -e "${COLOR_NO}"
}

exit_error() {
  echo
  echo -e "${BIBERCONF_TITLE}${COLOR_ERROR}"
  echo 1>&2 -e "$1"
  shift
  echo -en "${COLOR_INFO}"
  for line in "$@"; do
    echo 1>&2 -e "$line"
  done
  echo -e "${COLOR_NO}"
  exit 1
}

echo_info() {
  echo
  echo -e "${BIBERCONF_TITLE}${COLOR_INFO}"
  for line in "$@"; do
    echo -e "$line"
  done
  echo -e "${COLOR_NO}"
}

read_reply() {
  echo
  echo -e "${BIBERCONF_TITLE}"
  local array
  array=("$@")
  local prompt
  prompt="${array[-1]}"
  echo -en "${COLOR_INFO}"
  for line in "${@:1:$#-1}"; do
    echo -e "$line"
  done
  echo -en "${COLOR_PROMPT}$prompt${COLOR_NO}"
  read -rp " "
  echo -e "${COLOR_NO}"
}

# https://stackoverflow.com/a/29613573
quote_re() { sed -e 's/[^^]/[&]/g; s/\^/\\^/g; $!a\'$'\n''\\n' <<<"$1" | tr -d '\n'; }
quote_subst() {
  IFS= read -d '' -r < <(sed -e ':a' -e '$!{N;ba' -e '}' -e 's/[&/\]/\\&/g; s/\n/\\&/g' <<<"$1")
  printf %s "${REPLY%$'\n'}"
}
