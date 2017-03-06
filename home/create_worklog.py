#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Generate tamplete for worklog of week
#
# Use: create_worklog.py [week [year]]
# by default week of today
#
# For example: script `date -d 2000-02-03 +%V` 2000
#
import sys, datetime, subprocess
from dateutil.relativedelta import relativedelta, MO

if len(sys.argv) == 1:
    week = datetime.date.today().isocalendar()[1]
else:
    week = int(sys.argv[1])

if len(sys.argv) < 3:
    year = datetime.date.today().year
else:
    year = int(sys.argv[2])

beginning = datetime.date(year, 1, 1) + \
    relativedelta(day = 4, weekday = MO(-1), weeks = week-1)

print "# Рабочий журнал "+beginning.strftime('%B %Y')+'\n'

for i in range(5):
    print "#### "+beginning.strftime('%A %d.%m.%y')+":"
#    print "- +2h Мониторинг работоспособности серверов"
    print "- +0h some_task\n"
    beginning += datetime.timedelta(1)
