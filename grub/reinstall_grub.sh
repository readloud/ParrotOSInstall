# let's assume you want to reinstall Grub on /dev/sda where Linux is on /dev/sda2

sudo mkdir /mnt/temp
sudo mount /dev/sda2 /mnt/temp

sudo mount --bind /dev /mnt/temp/dev &&
sudo mount --bind /dev/pts /mnt/temp/dev/pts &&
sudo mount --bind /proc /mnt/temp/proc &&
sudo mount --bind /sys /mnt/temp/sys

sudo chroot /mnt/temp

grub-install /dev/sda
grub-install --recheck /dev/sda
update-grub

exit &&
sudo umount /mnt/temp/sys &&
sudo umount /mnt/temp/proc &&
sudo umount /mnt/temp/dev/pts &&
sudo umount /mnt/temp/dev &&
sudo umount /mnt/temp