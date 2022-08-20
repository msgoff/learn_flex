#echo input path1 path2 as arguments
find "$1" -type f -exec sha256sum "{}" \; > /dev/shm/path1
find "$2" -type f -exec sha256sum "{}" \; > /dev/shm/path2
#./mmap_flex.out /dev/shm/path1 /dev/shm/path2


