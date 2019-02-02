#!/usr/bin/env bash

# e.g. SSHPASS environment variable
# export SSHPASS=xxx
#
# e.g. ~/.ssh/config
# Host xxx
#   HostName xxx.com
#   User xxx
#   SendEnv SSHPASS xxx

function main() {
	# NOTE: this filepath
	local now_ssh_cmd=$0
	local next_ssh_cmd=$(which -a $(basename $now_ssh_cmd) | tr ':' '\n' | grep -F $(dirname $now_ssh_cmd) -A2 | sed -n 2,2p)
	[[ -z $next_ssh_cmd ]] && echo 1>&2 "Not found original command!" && return 1

	local login_password=$($next_ssh_cmd -G "$@" | grep -A1 '^sendenv SSHPASS$' | sed -n 2,2p | cut -d' ' -f2-)
	[[ -n $login_password ]] && export SSHPASS=$login_password
	if type >/dev/null 2>&1 sshpass && [[ -n $SSHPASS ]]; then
		sshpass -e "$next_ssh_cmd" "$@"
	else
		"$next_ssh_cmd" "$@"
	fi
}
main "$@"
