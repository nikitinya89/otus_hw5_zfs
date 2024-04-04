# Otus Homework 5. ZFS
### Цель домашнего задания
Отработать навыки работы с созданием томов export/import и установкой параметров
- определить алгоритм с наилучшим сжатием
- определить настройки pool’a
- найти сообщение от преподавателей
- составить список команд, которыми получен результат с их выводами
### Описание домашнего задания
1. Определить алгоритм с наилучшим сжатием:
Определить какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4). Создать 4 файловых системы на каждой применить свой алгоритм сжатия. Для сжатия использовать либо текстовый файл, либо группу файлов.
2. Определить настройки пула.
С помощью команды zfs import собрать pool ZFS.
Командами zfs определить настройки:   
- размер хранилища
- тип pool
- значение recordsize
- какое сжатие используется
- какая контрольная сумма используется
3. Работа со снапшотами. Скопировать файл из удаленной директории. Восстановить файл локально. Найти зашифрованное сообщение в файле secret_message.
## Выволнение
Домашнее задание выполняется с помощью bash скрипта, добавленного в Vagrantfile. В результат работы скрипта будут в папке */home/vagrant* созданы 3 файла с полученными результатами: *compression*, *import* и *snap*.
### Определить алгоритм с наилучшим сжатием
Создаются 4 зеркалированных пула: *zpool1*, *zpool2*, *zpool3*, *zpool4*. На каждом пуле создается файловая система, на которые устанавливается разные алгоритмы сжатия. После записи файлов становится понятно, что самым эффективным сжатием обладает алгоритм *gzip*. Результат записывается в файл *compression*:
```
NAME          USED  AVAIL     REFER  MOUNTPOINT
zpool1       21.7M   330M     25.5K  /zpool1
zpool1/zfs1  21.6M   330M     21.6M  /zpool1/zfs1
zpool2       17.7M   334M     25.5K  /zpool2
zpool2/zfs2  17.6M   334M     17.6M  /zpool2/zfs2
zpool3       10.8M   341M     25.5K  /zpool3
zpool3/zfs3  10.7M   341M     10.7M  /zpool3/zfs3
zpool4       27.3M   325M     25.5K  /zpool4
zpool4/zfs4  27.2M   325M     27.2M  /zpool4/zfs4


zpool1/zfs1  compression    lzjb      local
zpool1/zfs1  compressratio  1.82x     -
zpool2/zfs2  compression    lz4       local
zpool2/zfs2  compressratio  2.23x     -
zpool3/zfs3  compression    gzip-9    local
zpool3/zfs3  compressratio  3.67x     -
zpool4/zfs4  compression    zle       local
zpool4/zfs4  compressratio  1.00x     -

gzip-9 is the most effective algorithm
```
### Определить настройки пула
Скачиваем архив и разархивируем. Командой *zpool import* импортируем каталог в пул. Командами *zpool status*, *zfs list* и *zfs get* узнаем необходимые настройки пула. Результаты записываются в файл *import*:
```
NAME   USED  AVAIL     REFER  MOUNTPOINT
otus  2.04M   350M       24K  /otus


  pool: otus
 state: ONLINE
  scan: none requested
config:

        NAME                                 STATE     READ WRITE CKSUM
        otus                                 ONLINE       0     0     0
          mirror-0                           ONLINE       0     0     0
            /home/vagrant/zpoolexport/filea  ONLINE       0     0     0
            /home/vagrant/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors


NAME  PROPERTY     VALUE      SOURCE
otus  recordsize   128K       local
otus  compression  zle        local
otus  checksum     sha256     local
```

### Работа со снапшотами
Скачиваем файл и восстанавливаем файловую систему из снэпшота. С помощью команды *find* находим файл с названием *secret_message*. Содержимое записывается в файл *snap*:
```
https://otus.ru/lessons/linux-hl/
```
