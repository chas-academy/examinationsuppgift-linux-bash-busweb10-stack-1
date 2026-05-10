#!/bin/bash

# -------------------------------------------------
# create_users.sh
# Skapar användare, mappar och välkomstfil
# Endast root får köra scriptet
# -------------------------------------------------

# 1. Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Fel: Du måste köra som root (sudo)."
  exit 1
fi

# 2. Kontrollera att minst en användare skickas in
if [ "$#" -eq 0 ]; then
  echo "Användning: $0 användare1 användare2 ..."
  exit 1
fi

# 3. Loop genom alla användare
for user in "$@"
do
  echo "Skapar användare: $user"

  # Skapa användare (med hemkatalog)
  useradd -m "$user"

  # Definiera hemkatalog
  home="/home/$user"

  # 4. Skapa katalogstruktur
  mkdir -p "$home/Documents"
  mkdir -p "$home/Downloads"
  mkdir -p "$home/Work"

  # 5. Rättigheter (endast ägare har access)
  chmod 700 "$home/Documents"
  chmod 700 "$home/Downloads"
  chmod 700 "$home/Work"

  # 6. Skapa welcome-fil
  echo "Välkommen $user" > "$home/welcome.txt"
  echo "" >> "$home/welcome.txt"
  echo "Andra användare i systemet:" >> "$home/welcome.txt"
  cut -d: -f1 /etc/passwd >> "$home/welcome.txt"

  # 7. Sätt korrekt ägarskap
  chown -R "$user:$user" "$home"

done

echo "Alla användare skapade!"
