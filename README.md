# sshpass_wrapper

I have not confirmed this command yet...

* set this command on `$PATH`

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
