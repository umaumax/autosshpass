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
	local now_cmd_path=$0
	local now_cmd=$(basename $now_cmd_path)
	local next_cmd_path=$(which -a $now_cmd | tr ':' '\n' | grep -F $(dirname $now_cmd_path) -A2 | sed -n 2,2p)
	if [[ -z $next_cmd_path ]]; then
		if ! type >/dev/null 2>&1 $now_cmd; then
			echo 1>&2 "Not found original '$now_cmd' command!"
			return 1
		fi
		local next_cmd_path=$now_cmd
	fi

	# NOTE: e.g. scp or rsync ?
	local ssh_cmd='ssh'
	if [[ $now_cmd == "ssh" ]]; then
		local ssh_cmd="$next_cmd_path"
	fi

	local login_password=$($ssh_cmd -G "$@" 2>/dev/null | grep -A1 '^sendenv SSHPASS$' | sed -n 2,2p | cut -d' ' -f2-)
	[[ -n $login_password ]] && export SSHPASS=$login_password
	if type >/dev/null 2>&1 sshpass && [[ -n $SSHPASS ]]; then
		sshpass -e "$next_cmd_path" "$@"
	else
		"$next_cmd_path" "$@"
	fi
}
main "$@"
