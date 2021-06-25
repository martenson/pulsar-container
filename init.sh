#!/usr/bin/env sh


. /mnt/pulsar/venv/bin/activate && \
pulsar \
-m webless \
-c '/mnt/pulsar/config' \
--daemon \
--daemon-log-file '/mnt/pulsar/pulsar.log'
