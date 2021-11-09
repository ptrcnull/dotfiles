function squash() ( mksquashfs "$1" "$1.zst.sfs" -comp zstd -Xcompression-level 22 ) 
