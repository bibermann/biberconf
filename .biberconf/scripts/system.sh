#!/usr/bin/env bash

is_debian() {
    [ -f "/etc/debian_version" ] \
        || grep -q -Ei 'debian|buntu|mint' /etc/issue \
        || grep -q -Ei '^ID(_LIKE)=.*(debian|buntu|mint)' /etc/*release \
        || grep -q -Ei '^ID(_LIKE)=.*(debian|buntu|mint)' /usr/lib/*release
}

is_arch() {
    [ -f /etc/arch-release ] \
        || grep -q -Ei 'arch' /etc/issue \
        || grep -q -Ei '^ID(_LIKE)=.*arch' /etc/*release \
        || grep -q -Ei '^ID(_LIKE)=.*arch' /usr/lib/*release
}

is_gui() {
    [ -n "${DISPLAY:-}" ]
}
