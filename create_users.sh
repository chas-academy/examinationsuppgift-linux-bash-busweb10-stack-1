#!/bin/bash
# -----------------------------------------
# Script för att skapa användare automatiskt
# -----------------------------------------

# 1. Kontrollera att användaren är root
if [ "$EUID" -ne 0 ]; then
  echo "Fel: Du måste köra detta script som root!"
  exit 1
fi

# 2. Kontrollera att minst en användare skickas in
if [ "$#" -lt 1 ]; then
  echo "Användning: $0 användare1 användare2 ..."
  exit 1
fi

# 3. Loopar igenom alla användare som skickats in
for user in "$@"
do
  echo "Skapar användare: $user"

  # Skapa användare
  useradd -m "$user"

  # Skapa mappar i hemkatalogen
  mkdir -p /home/"$user"/Documents
  mkdir -p /home/"$user"/Downloads
  mkdir -p /home/"$user"/Work

  # Sätt rättigheter (endast ägaren får åtkomst)
  chmod 700 /home/"$user"/Documents
  chmod 700 /home/"$user"/Downloads
  chmod 700 /home/"$user"/Work

  # Skapa welcome.txt
  echo "Välkommen $user" > /home/"$user"/welcome.txt

  echo "" >> /home/"$user"/welcome.txt
  echo "Andra användare i systemet:" >> /home/"$user"/welcome.txt

  # Lista alla användare
  cut -d: -f1 /etc/passwd >> /home/"$user"/welcome.txt

  # Sätt ägarskap
  chown -R "$user":"$user" /home/"$user"

done

echo "Klart! Alla användare har skapats."
