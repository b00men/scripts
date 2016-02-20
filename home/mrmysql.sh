#!/bin/sh

# Грубый пример проброса ssh тоннелей.
# Пробрасывает mysql до air-tomsk на localhost:3307
# Пробрасывает mysql до marketradio на localhost:3308

ssh -f air-tomsk.marketradio.ru -L 3307:air-tomsk.marketradio.ru:3306 -N
ssh -f marketradio.ru -L 3308:marketradio.ru:3306 -N
echo complite!
