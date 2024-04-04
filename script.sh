#!/bin/bash

sudo zpool create zpool1 mirror sdb sdc
sudo zpool create zpool2 mirror sdd sde
sudo zpool create zpool3 mirror sdf sdg
sudo zpool create zpool4 mirror sdh sdi

for i in {1..4}; do sudo zfs create zpool$i/zfs$i; done

sudo zfs set compression=lzjb zpool1/zfs1
sudo zfs set compression=lz4 zpool2/zfs2
sudo zfs set compression=gzip-9 zpool3/zfs3
sudo zfs set compression=zle zpool4/zfs4

for i in {1..4}; do sudo wget -P /zpool$i/zfs$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done

zfs list > compression
echo -e "\n" >> compression
zfs get compression,compressratio | grep zfs >> compression
echo -e "\ngzip-9 is the most effective algorithm" >> compression

wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download' 
tar -xzvf archive.tar.gz
sudo zpool import -d zpoolexport/ otus
zfs list otus > import
echo -e "\n"  >> import
zpool status otus >> import
echo -e "\n"  >> import
zfs get recordsize,compression,checksum otus >> import

wget -O otus_task2.file --no-check-certificate 'https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download'
sudo zfs receive otus/test@today < otus_task2.file
echo "The secret message is:" > snap
find /otus/test -name "secret_message" -exec cat {} \; >> snap
