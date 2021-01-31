# **Сборка ядра Linux из исходников**


### **Установка необходимого ПО**
```
# Установка более свежей версии gcc, поскольку в репозитории sentosсамая последняя версия - 4
# Устанавливаем самым простым способом через пакет разработчика devtoolset-7
yum install centos-release-scl -y
yum install devtoolset-7 -y
scl enable devtoolset-7 bash
# Устанавливаем дополнительные инструментыю wget можнор не ставить, можно использовать curl
yum install -y ncurses-devel make bc bison flex elfutils-libelf-devel openssl-devel grub2
yum install wget -y
```

### **Закачиваем исходники нужного ядра, распаковываем и переходим в директории с исходниками**
```
cd /usr/src
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.9.tar.xz
tar -xvf linux-5.9.9.tar.xz
cd linux-5.9.9
```

```
cp /boot/config-* .config
make oldconfig
make -j2
make modules_install
make install
```
yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
# Install new kernel
yum --enablerepo elrepo-kernel install kernel-ml -y
# Remove older kernels (Only for demo! Not Production!)
rm -f /boot/*3.10*
# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0

### **grub update**
После успешной установки нам необходимо сказать системе, что при загрузке нужно использовать новое ядро. В случае обновления ядра на рабочих серверах необходимо перезагрузиться с новым ядром, выбрав его при загрузке. И только при успешно прошедших загрузке нового ядра и тестах сервера переходить к загрузке с новым ядром по-умолчанию. В тестовой среде можно обойти данный этап и сразу назначить новое ядро по-умолчанию. 

Обновляем конфигурацию загрузчика:
```
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```
Выбираем загрузку с новым ядром по-умолчанию:
```
sudo grub2-set-default 0
```

Перезагружаем виртуальную машину:
```
sudo reboot
```

После перезагрузки виртуальной машины (3-4 минуты, зависит от мощности хостовой машины) заходим в нее и выполняем:

```
uname -r
```
### **Примечание**
Использована команда :
```
make oldconfig
```
Но она требует интерактивного взаимодействия с пользователем.
При попытке использовать команду:
```
make defconfig
```
Которая создает конфигурационный файл по умолчанию, команда 
```
make install
```
выполняется с ошибкой:
```
dracut:Failed to install module hv_netvsc
```

