#!/usr/bin/python
# Req:
#   apt-get install libusb-dev python-usb
#   pip install pyusb
#
from usb.core import find as finddev
dev = finddev(idVendor=0x13d3, idProduct=0x3402)
dev.reset()
