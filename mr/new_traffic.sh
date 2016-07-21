#!/bin/sh

# Скрипт удаленного разворачивания нового трафика
# на аудио-машинке со старым трафиком.
# Рекомендуется прочитать, исправить под текущие
# реалии или написать универсальный	и автономный скрипт,
# который будет являться частью более стабильной системы.

# '|| exit 1' обрывает скрипт, если возникает непредвиденная
# ошибка на любом из этапов. Тем самым дальнейшие этапы не вредят.
# Важно! В таком случае нужно учитывать, что уже отработано.
# Либо переписать каждый этап так, чтобы он мог без вреда исполняться многократно.

export PATH=$PATH:/usr/bin/:/usr/sbin/

# т.к. новый трафик перетирает все индивидуальные конфиги,
# включая pptp, то бейкапим для последующего восстоновления.
# (todo: игнорировать ошибки, если сервер новый)
crontab -l > /root/crontab.bak
cp /etc/ppp/chap-secrets /root/chap-secrets.bak
cp /etc/ppp/peers/head /root/head.bak

# Исключительно для автоматизации перемещаем mpd.conf,
# чтобы избежать вопроса замены файла при обновлении mpd.
# Заодно бейкапим, если в конфиге нечто отличающееся от стандарта
# (Например, ссылки стройпарка)
mv /etc/mpd.conf /root/mpd.conf.bak

# Готовим систему, ставим минимум, если машинка новая.
# Если старая, то докачаем требуемый гит
apt-get update && apt-get install -y git mpd mpc ncmpc rsync pptp-linux php5-cli ntp ntpdate mc alsa-base alsa-tools tzdata tzdata-java lftp alsa-utils || exit 1

# Костыль обхода ограничений gitlab'a на вход
# Внимание! не продуман вариант, если ключи уже есть
cd /root/.ssh
wget http://marketradio.ru/id_rsa.pub
wget http://marketradio.ru/id_rsa
chmod 400 /root/.ssh/id_rsa
chmod 444 /root/.ssh/id_rsa.pub
chown -hR root:root /root/.ssh/id_rsa*

# Обход бага нового трафика - молча не будет ничего делать,
# если папка service существует (а там у нас старый трафик).
mv /opt/service /opt/service_old

# Обход вопроса git клиента, который еще не
# встречал fingerprint git-сервера.
echo "StrictHostKeyChecking no" >> /root/.ssh/config

# Ставим новый трафик (внутри исполняются скрипты и клонируется еще одно репо)
git clone git@gitlab.com:a-s-dorohin/audio.git /opt/chroot/ && /opt/chroot/install || exit 1

# Откатываем костыль обхода вопроса git'a
# (todo: Не #, а удаление. Отработка даже при ошибке на предыдущей строке.)
sed -i 's/^StrictHostKeyChecking no/#StrictHostKeyChecking no/' /root/.ssh/config

# Восстонавливаем конфиги соединения
# (todo: игнорируем ошибки, если сервер новый)
cp /root/chap-secrets.bak /etc/ppp/chap-secrets
cp /root/head.bak /etc/ppp/peers/head

# Чистим rc.local от старого трафика
# (todo: аналогично обработать vpnstart)
sed -i 's/^\/opt\/market.php/#\/opt\/market.php/' /etc/rc.local

# Если расбери - раскомментируем hw
uname -a | grep arm > /dev/null && sed -i 's/#        device                  "hw:0,0"/        device                  "hw:0,0"/' /etc/mpd.conf

# Добавляем в configs.py checkconneckt (иначе vpn пинать некому)
sed -i 's/\/usr\/bin\/getmusic\\n/\/usr\/bin\/getmusic\\n*\/10 * * * * \/usr\/bin\/checkconnect\\n/' /opt/service/libs/configs.py

# Для видеосерверов, аля изумруд.
# Т.к. видео сервер нового трафика требует всю вереницу аудио скриптов и настроек,
# то заставляем игнорировать правила старта и останова (видеоплеер не поддерживает такие функции)
#sed -i 's/\/usr\/bin\/playmusic/\/bin\/true/' /opt/service/libs/configs.py
#sed -i 's/\/usr\/bin\/stopmusic/\/bin\/true/' /opt/service/libs/configs.py

# todo: Автоматизировать и грамотно обработать
# 1) Распарсить и вытащить полезное (индивидуальное) из crontab.bak
# 2) Грамотно добавить результат предыдущего в config.py
# 3) Решить, какое поведение должно быть на счет mpd.conf
echo "Напоминание."
echo "Не забудьте просмотреть /root/crontab.bak и при необходимости поправить /opt/service/lib/config.py!"
echo "Верните mpd.conf.bak, если в нем были нестандартные настройки."