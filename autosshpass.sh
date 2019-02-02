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
	local cmd_name=$(basename $0)
	local cmd
	[[ $cmd_name =~ ssh ]] && local cmd='ssh'
	[[ $cmd_name =~ scp ]] && local cmd='scp'
	[[ $cmd_name =~ rsync ]] && local cmd='rsync'
	if ! type >/dev/null 2>&1 sshpass; then
		$cmd "$@"
		return
	fi
	[[ -z $cmd ]] && echo 1>&2 "Unknown corresponding command to '$cmd_name'!" && return 1

	local host
	for arg in "$@"; do
		[[ $arg =~ -.* ]] && continue
		if [[ $cmd == "ssh" ]]; then
			local host=$arg
			break
		fi
		# NOTE: for scp or rsync
		[[ $arg =~ .*:.* ]] && local host=${arg%:*}
	done
	# NOTE: uncomment for localhost to localhost
	# [[ -z $host ]] && echo 1>&2 "Unknown host name" && return 1

	local login_password=$(ssh -G "$host" 2>/dev/null | grep -A1 '^sendenv SSHPASS$' | sed -n 2,2p | cut -d' ' -f2-)
	[[ -n $login_password ]] && export SSHPASS=$login_password
	if [[ -n $SSHPASS ]]; then
		sshpass -e "$cmd" "$@"
	else
		$cmd "$@"
	fi
}
main "$@"
