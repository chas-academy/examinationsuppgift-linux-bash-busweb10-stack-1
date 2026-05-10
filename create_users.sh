#!/bin/bash
# --------------------------------------------
# Skapar användare + katalogstruktur + welcome
# Endast root får köra scriptet
# --------------------------------------------

# 1. Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Fel: Du måste köra som root!"
  exit 1
fi

# 2. Kontrollera att argument finns
if [ "$#" -eq 0 ]; then
  echo "Användning: $0 användare1 användare2 ..."
  exit 1
fi

# 3. Loop genom alla användare
for user in "$@"
do
  echo "Skapar användare: $user"

  # Skapa användare (utan fel om redan finns)
  id "$user" &>/dev/null
  if [ $? -ne 0 ]; then
    useradd -m "$user"
  fi

  HOME_DIR="/home/$user"

  # 4. Skapa kataloger
  mkdir -p "$HOME_DIR/Documents"
  mkdir -p "$HOME_DIR/Downloads"
  mkdir -p "$HOME_DIR/Work"

  # 5. Sätt rättigheter (endast ägare)
  chmod 700 "$HOME_DIR/Documents"
  chmod 700 "$HOME_DIR/Downloads"
  chmod 700 "$HOME_DIR/Work"

  # 6. Skapa welcome-fil
  echo "Välkommen $user" > "$HOME_DIR/welcome.txt"
  echo "" >> "$HOME_DIR/welcome.txt"
  echo "Andra användare i systemet:" >> "$HOME_DIR/welcome.txt"
  cut -d: -f1 /etc/passwd >> "$HOME_DIR/welcome.txt"

  # 7. Sätt ägare korrekt
  chown -R "$user:$user" "$HOME_DIR"

done

echo "Klart!"
