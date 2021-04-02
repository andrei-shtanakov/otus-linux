# PAM (Pluggable Authentication Modules)

Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
дать конкретному пользователю права работать с докером и возможность рестартить докер сервис


* [Vagrantfile](Vagrantfile)
* [Скрипт, вызываемый из Vagrantfile](script.sh)

Файл скрипта script.sh должен находиться в той же директории, что и Vagrantfile

Создаваемая виртуальная машина SentOS7 будет уже содержать установленный Docker.
Кроме того, будут созданы 4 пользователя:
user, user1, user2, user3 с паролями Zz12345, Uxer01, User02, User03.
Так же будет создана группа admin, куда входит пользователь user, и группа docker, куда входит пользователь user1.

проверка разрешения осуществляется скриптом в файле /usr/local/bin/test_login.sh
### /usr/local/bin/test_login.sh
```
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
```
добавляем проверку в PAM (добавляем строки)
### /etc/pam.d/sshd
```
account    required     pam_nologin.so
account    required     pam_exec.so /usr/local/bin/test_login.sh
```

Правило для проверки разрешения на перезапуск/запуск/остановку сервиса docker в файле /usr/share/polkit-1/rules.d/57-manage-daemon-name.rules
### /usr/share/polkit-1/rules.d/57-manage-daemon-name.rules
```
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units" &&
        subject.user == "user1") {
        return polkit.Result.YES;
    }
});
```

