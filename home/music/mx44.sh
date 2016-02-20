#!/bin/sh
qjackctl -p dual -s &
jack_mixer -c mixer-piano &
jack-rack jack-rack-mx44 &
mx44 &	