#!/bin/bash

# 1. Root check
if [ "$EUID" -ne 0 ]; then
  echo "Must be root"
  exit 1
fi

# 2. Check arguments
if [ $# -eq 0 ]; then
  echo "Usage: $0 user1 user2 ..."
  exit 1
fi

# 3. Loop users
for user in "$@"
do
  useradd -m "$user"

  home="/home/$user"

  # Create folders
  mkdir -p "$home/Documents"
  mkdir -p "$home/Downloads"
  mkdir -p "$home/Work"

  # Permissions
  chmod 700 "$home/Documents"
  chmod 700 "$home/Downloads"
  chmod 700 "$home/Work"

  # Welcome file
  echo "Välkommen $user" > "$home/welcome.txt"
  echo "" >> "$home/welcome.txt"
  echo "Andra användare:" >> "$home/welcome.txt"
  cut -d: -f1 /etc/passwd >> "$home/welcome.txt"

  # Ownership
  chown -R "$user:$user" "$home"

done
