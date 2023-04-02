# restic systemd backups with Telegram notification

This repository contains systemd units and timers for automatic [restic](https://restic.net) backups.
In case of a failure, the error log is sent to a Telegram bot using [telegram.sh](https://github.com/fabianonline/telegram.sh).
