#!/usr/bin/env bash

is_debian() {
  if [ -z ${is_debian_exit_code+x} ]; then
    [ -f /etc/debian_version ] \
      || grep -q -Ei 'debian|buntu|mint' /etc/issue \
      || grep -q -Ei '^ID(_LIKE)=.*(debian|buntu|mint)' /etc/*release \
      || grep -q -Ei '^ID(_LIKE)=.*(debian|buntu|mint)' /usr/lib/*release
    is_debian_exit_code=$?
  fi
  return "$is_debian_exit_code"
}

is_arch() {
  if [ -z ${is_arch_exit_code+x} ]; then
    [ -f /etc/arch-release ] \
      || grep -q -Ei 'arch' /etc/issue \
      || grep -q -Ei '^ID(_LIKE)=.*arch' /etc/*release \
      || grep -q -Ei '^ID(_LIKE)=.*arch' /usr/lib/*release
    is_arch_exit_code=$?
  fi
  return "$is_arch_exit_code"
}

is_gui() {
    [ -n "${DISPLAY:-}" ]
}
