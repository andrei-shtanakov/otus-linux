# Задание 2 курса "Администратор Linux"

Vagrantfile, который сразу собирает систему с подключенным рейдом


* [Vagrantfile](Vagrantfile)
* [Скрипт, вызываемый из Vagrantfile](script.sh)

Файл скрипта script.sh должен находиться в той же директории, что и Vagrantfile

## Часть Vagrantfile, где вызывается скрипт
 	  box.vm.provision "shell", inline: <<-SHELL
	      mkdir -p ~root/.ssh
              cp ~vagrant/.ssh/auth* ~root/.ssh
	      yum install -y mdadm smartmontools hdparm gdisk
	      sh /vagrant/script.sh
  	  SHELL

## Содержание файла скрипта script.sh

### **Занулим суперблоки:**
```
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
```
### **Удаляем старые метаданные и подпись на дисках:**
```
wipefs --all --force /dev/sd{b,c,d,e,f}
```
### **Создаем массив 10 уровня из 5 дисков
```
mdadm --create --verbose /dev/md0 -l 10 -n 5 /dev/sd{b,c,d,e,f}
```
mkdir /etc/mdadm
### **Создание конфигурационного файла mdadm.conf**
```
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
```
### **Создаем раздел GPT на RAID**
```
parted -s /dev/md0 mklabel gpt
```
### **Создаем партиции**
```
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%
```
### **Создаем ФС**
```
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
```
### **Монтирование их по каталогам**
```
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
```

