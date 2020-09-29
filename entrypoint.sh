#!/usr/bin/env bash
# This is a k8s concession, since you can not map a volume to a specific
# file, you must map an entire directory. This simply moves the file to
# where the stats cronjobs are expecting to find it.
cp /stats/config/config.ini /stats/config.ini

# Initialization is idempotent, and creates files which will die with the
# container.
/stats/settings.run

if "$QUEST_CLEAN"
then
  sed -i '$ s/# //g' /stats/crontab.txt
fi

crontab /stats/crontab.txt
crontab -l

# Run the cron deaemon
/usr/sbin/cron -f -L /dev/stdout
