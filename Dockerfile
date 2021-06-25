FROM ubuntu:focal

RUN apt update && \
apt -y install software-properties-common && \
add-apt-repository --yes --update ppa:ansible/ansible && \
apt -y install ansible && \
apt -y install curl && \
apt -y install libgnutls28-dev build-essential gcc python3-dev libcurl4-openssl-dev libssl-dev

ADD playbook /playbook

RUN cd playbook && \
ansible-galaxy install galaxyproject.pulsar && \
ansible-playbook pulsar.yml

RUN apt -y remove build-essential gcc python3-dev libgnutls28-dev
RUN apt -y autoremove && \
apt -y clean

RUN chown -R pulsar:pulsar /mnt/pulsar/files && \
chown pulsar:pulsar /mnt/pulsar/deps

ADD init.sh /init.sh
RUN chmod +x /init.sh
CMD ["/init.sh"]
