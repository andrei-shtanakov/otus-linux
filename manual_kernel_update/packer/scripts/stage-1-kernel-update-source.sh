#!/bin/bash


# Установка более свежей версии gcc, поскольку в репозитории sentosсамая последняя версия - 4
# Устанавливаем самым простым способом через пакет разработчика devtoolset-7
yum install centos-release-scl -y
yum install devtoolset-7 -y
# устанавливаем переменную $PATH таким образом, что бы вызывался gcc 7 версии
export PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rh/devtoolset-7/:$PATH
#scl enable devtoolset-7 bash
# Устанавливаем дополнительные инструментыю wget можнор не ставить, можно использовать curl
yum install -y ncurses-devel make bc bison flex elfutils-libelf-devel openssl-devel grub2
yum install wget -y
cd /usr/src
# закачиваем исходники ядра версии 5.9.9
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.9.tar.xz
tar -xvf linux-5.9.9.tar.xz
cd linux-5.9.9
# сборка и компиляция ядра
cp /boot/config-* .config
make olddefconfig
make -j2
make modules_install
make install
# Remove older kernels (Only for demo! Not Production!)
rm -f /boot/*3.10*
# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
echo "Grub update done."
# Reboot VM
shutdown -r now

