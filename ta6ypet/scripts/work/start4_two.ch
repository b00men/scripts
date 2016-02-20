#!/bin/sh
cd /opt/games/cod4
killall -w cod4_lnxded-bin
./cod4_lnxded +set dedicated 1 +sets gamestartup "`date +"%D %T"`" +set net_ip localhost +set net_port 28960 +set sv_punkbuster 0 +set loc_language 6 +exec codserver.cfg +map_rotate>/opt/games/cod4/log/start4.log 2>/opt/games/cod4/log/start4.log &
killall -w cod4_lnxded-bin_2
./cod4_lnxded_2 +set dedicated 1 +sets gamestartup "`date +"%D %T"`" +set net_ip localhost +set net_port 28961 +set sv_punkbuster 1 +set loc_language 6 +exec codserver_2.cfg +map_rotate>/opt/games/cod4/log/start4_2.log 2>/opt/games/cod4/log/start4_2.log &

