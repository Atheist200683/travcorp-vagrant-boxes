#!/bin/bash

HOST_SSH_DIR=/vagrant/ssh
GUEST_SSH_DIR=/home/oracle/.ssh

echo -e "Provisioning SSH..."
su oracle -c "rm -rf "$GUEST_SSH_DIR";
mkdir "$GUEST_SSH_DIR";
cp "$HOST_SSH_DIR"/* "$GUEST_SSH_DIR";
chmod 700 "$GUEST_SSH_DIR";
chmod 644 "$GUEST_SSH_DIR"/id_rsa.pub "$GUEST_SSH_DIR"/known_hosts;
chmod 600 "$GUEST_SSH_DIR"/id_rsa"
echo -e "SSH provisioned!"
exit $?