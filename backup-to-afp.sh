#!/bin/sh

# Backups a directory to an AFP share with rsync.
#
# Usage: backup-to-afp.sh DIRECTORY AFP_URL
#
# Example: backup-to-afp.sh /path/to/MyDirectory afp://192.168.0.1/MyDirectoryBackup
#
# If you don't provide a username and password in the url it will check the OS X Keychain
# for a password for the current user. If not found it will prompt for credentials.

dir=$1
afp_url=$2

afp_url_arr=(${afp_url//\// })

server=${afp_url_arr[1]}
volume=${afp_url_arr[2]}

mountpoint=/Volumes/$volume

mkdir $mountpoint

if [[ $server == *"@"* ]]
then
  mount_afp -i $afp_url $mountpoint
else
  user=$USER
  pwd=$(security 2>&1 >/dev/null find-internet-password -gs $server -a $user | ruby -e 'print $1 if STDIN.gets =~ /^password: "(.*)"$/')

  if [ -n "$pwd" ]
  then
    mount_afp ${afp_url/\/\//\/\/$user:$pwd@} $mountpoint
  else
    mount_afp -i $afp_url $mountpoint
  fi
fi

rsync -aP --delete --exclude=.DS_Store \
  --exclude=.afpDeleted* \
  --exclude=.DocumentRevisions-V100 \
  --exclude=.Spotlight-V100 \
  --exclude=.TemporaryItems \
  --exclude=.fseventsd \
  --exclude=.VolumeIcon.icns \
  --exclude=.apdisk \
  --exclude=.disk_label \
  --exclude=.disk_label_2x \
  --exclude=tmbootpicker.efi \
  $dir/ $mountpoint

umount $mountpoint
