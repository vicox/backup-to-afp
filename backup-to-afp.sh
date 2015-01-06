dir=$1
afp_url=$2

afp_url_arr=(${afp_url//\// })

sharepoint=${afp_url_arr[2]}
mountpoint=/Volumes/$sharepoint


mkdir $mountpoint
mount_afp -i $afp_url $mountpoint

rsync -aP --delete --exclude=.DS_Store --exclude=.afpDeleted* $dir/ $mountpoint

umount $mountpoint
