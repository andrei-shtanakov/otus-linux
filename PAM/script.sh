#!/bin/bash

# create users:
sudo useradd user1 && sudo useradd user2 && sudo useradd user3 && sudo useradd user

echo "User01"|sudo passwd --stdin user1 && \
echo "User02"|sudo passwd --stdin user2 && \
echo "User03"|sudo passwd --stdin user3 && \
echo "Zz12345"|sudo passwd --stdin user

# пользователь user будет в группе admin и ему будет разрешен вход в систему в выходные дни

sudo groupadd admin
sudo usermod -a -G admin user

# пользователя user1 добавляем в группу docker
sudo usermod -aG docker user1

sudo bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"

# скрипт проверки права входа в систему в выходной день
cat <<'EOF' >> /usr/local/bin/test_login.sh
#!/bin/bash
weekday=$(date +%w)  # 0 is Sunday, 6 is Saturday
if [ $PAM_DROUP = "admin" ]; then
  exit 0
elif [ $weekday -eq 6 ]; then
  exit 1
elif [ $weekday -eq 0 ]; then
  exit 1
else; then
  exit 0
fi
EOF

# добавляем проверку в PAM
cat "account    required     pam_nologin.so" >> /etc/pam.d/sshd
cat "account    required     pam_exec.so /usr/local/bin/test_login.sh" >> /etc/pam.d/sshd

# добавляем правило на проверку права пользователя работать с systemctl (перезауск docker)
cat <<'EOF' >> /usr/share/polkit-1/rules.d/57-manage-daemon-name.rules
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units" &&
        subject.user == "user1") {
        return polkit.Result.YES;
    }
});
EOF

