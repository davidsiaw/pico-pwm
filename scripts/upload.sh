set -e

echo "mounting /mnt/pico"
mkdir -p /mnt/pico
mount /dev/sda1 /mnt/pico

echo "copying $1 to /mnt/pico"
cp $1 /mnt/pico
sync

echo "unmounting /mnt/pico"
umount /mnt/pico
rm -r /mnt/pico

