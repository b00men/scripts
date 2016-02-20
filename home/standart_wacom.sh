#!/bin/bash

# Переназначение действий кнопок планшета.
# Отключение функционала тачпада.

xsetwacom set "Wacom Bamboo 2FG 4x5 Finger pad" Button 3 "key shift"
xsetwacom set "Wacom Bamboo 2FG 4x5 Finger pad" Button 8 "key ctrl"
xsetwacom set "Wacom Bamboo 2FG 4x5 Finger pad" Button 1 "key ctrl z"
xsetwacom set "Wacom Bamboo 2FG 4x5 Finger pad" Button 9 "key ctrl y"
xsetwacom set "Wacom Bamboo 2FG 4x5 Finger touch" touch off

