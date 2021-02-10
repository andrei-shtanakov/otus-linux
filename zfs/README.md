# Задание 4 курса "Администратор Linux" 
## Практические навыки работы с ZFS

Цель: Отрабатываем навыки работы с созданием томов export/import и установкой параметров.

Определить алгоритм с наилучшим сжатием.
Определить настройки pool’a
Найти сообщение от преподавателей

Результат:
список команд которыми получен результат с их выводами

### Определить алгоритм с наилучшим сжатием
* [Файл - список команд которыми получен результат с их выводами](zfs)

- Команды применения алгоритмов сжатия к файловым системам:
zfs set compression=lz4 testpool/fs1
zfs set compression=gzip-9 testpool/fs2
zfs set compression=lzjb testpool/fs3
zfs set compression=zle testpool/fs4

- вывод команды из которой видно какой из алгоритмов лучше
```
[root@server vagrant]# zfs list
NAME           USED  AVAIL     REFER  MOUNTPOINT
testpool      9.03M   823M       28K  /mnt
testpool/fs1  2.02M   823M     2.02M  /mnt/fs1
testpool/fs2  1.23M   823M     1.23M  /mnt/fs2
testpool/fs3  2.41M   823M     2.41M  /mnt/fs3
testpool/fs4  3.23M   823M     3.23M  /mnt/fs4
```
Лучший алгоритм сжатия - gzip-9

### Определить настройки pool’a
* [Файл - список команд которыми получен результат с их выводами](zfs1)
* [файл с описанием настроек settings](settings)
```
NAME  PROPERTY              VALUE                  SOURCE
otus  type                  filesystem             -
otus  available             350M                   -
otus  recordsize            128K                   local
otus  checksum              sha256                 local
otus  compression           zle                    local
```
### Найти сообщение от преподавателей
* [Файл - список команд которыми получен результат с их выводами](zfs2)

Cообщение:
```
https://github.com/sindresorhus/awesome
```

