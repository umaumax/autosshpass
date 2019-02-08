# auto{ssh,scp,rsync}pass

## how to use
* just replace
  * `ssh` to `autosshpass`
  * `scp` to `autoscppass`
  * `rsync` to `autorsyncpass`
  * `xxx` to `autoxxxpass` or `export AUTOSSHPASS_CMD='xxx'`

## settings for auto password input
### way.1 SSHPASS environment variable
```
export SSHPASS=xxx
```

### way.2 `~/.ssh/config`
```
Host xxx
  HostName xxx.com
  User xxx
  SendEnv SSHPASS xxx
```

## Required
* `sshpass`
