# backup-to-afp.sh

`backup-to-afp.sh` is a bash script that backups a directory to an AFP share with rsync.

Usage:

    backup-to-afp.sh DIRECTORY AFP_URL

Example:

    backup-to-afp.sh /path/to/MyDirectory afp://192.168.0.1/MyDirectoryBackup

If you don't provide a username and password in the url it will check the OS X Keychain for a password for the current user. If not found it will prompt for credentials.