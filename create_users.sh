#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Du måste vara root"
  exit 1
fi

for user in "$@"
do
  echo "Skapar användare: $user"

  useradd -m "$user"

  mkdir -p /home/"$user"/Documents
  mkdir -p /home/"$user"/Downloads
  mkdir -p /home/"$user"/Work

  chmod 700 /home/"$user"/Documents
  chmod 700 /home/"$user"/Downloads
  chmod 700 /home/"$user"/Work

  echo "Välkommen $user" > /home/"$user"/welcome.txt
  echo "" >> /home/"$user"/welcome.txt
  echo "Andra användare:" >> /home/"$user"/welcome.txt
  cut -d: -f1 /etc/passwd >> /home/"$user"/welcome.txt

  chown -R "$user":"$user" /home/"$user"

done
