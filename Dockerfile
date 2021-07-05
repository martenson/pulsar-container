FROM ubuntu:focal

RUN apt update && \
apt -y install software-properties-common && \
add-apt-repository --yes --update ppa:ansible/ansible && \
apt -y install ansible && \
apt -y install curl && \
apt -y install strace gdb iputils-ping && \
apt -y install libgnutls28-dev build-essential gcc python3-dev libcurl4-openssl-dev libssl-dev

# Run Ansible playbook to install Pulsar
ADD playbook /playbook
RUN cd playbook && \
ansible-galaxy install galaxyproject.pulsar && \
ansible-playbook pulsar.yml
RUN chown -R pulsar:pulsar /mnt/pulsar/files && \
chown pulsar:pulsar /mnt/pulsar/deps

# Install custom metacentrum PBS packages
ADD .deb/libpbspro_19.0.0-25_amd64.deb /libpbspro_19.0.0-25_amd64.deb
ADD .deb/pbspro-client_19.0.0-25_amd64.deb /pbspro-client_19.0.0-25_amd64.deb
RUN apt -y install libtcl8.6 libtk8.6
RUN dpkg -i /libpbspro_19.0.0-25_amd64.deb
RUN dpkg -i /pbspro-client_19.0.0-25_amd64.deb
RUN sed -i 's/CHANGE_THIS_TO_PBS_PRO_SERVER_HOSTNAME/elixir-pbs.elixir-czech.cz/' /etc/pbs.conf
RUN echo 'PBS_AUTH_METHOD=GSS' >> /etc/pbs.conf

# Cleanup the system to reduce the image size
RUN apt -y remove build-essential gcc python3-dev libgnutls28-dev
RUN rm /libpbspro_19.0.0-25_amd64.deb /pbspro-client_19.0.0-25_amd64.deb
ADD common_cleanup.sh /usr/bin/common_cleanup.sh
RUN chmod +x /usr/bin/common_cleanup.sh && \
sh /usr/bin/common_cleanup.sh

ADD init.sh /init.sh
RUN chmod +x /init.sh
CMD ["/init.sh"]
