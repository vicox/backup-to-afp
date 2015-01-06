#!/bin/sh

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

rsync -aP --delete --exclude=.DS_Store --exclude=.afpDeleted* $dir/ $mountpoint

umount $mountpoint
