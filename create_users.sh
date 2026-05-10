#!/bin/bash

# =========================================
# Script för att skapa användare
# Skapar även mappar och welcome.txt
# =========================================

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste köra scriptet som root!"
    exit 1
fi

# Loopar igenom alla användarnamn som skickas in
for username in "$@"
do

    echo "Skapar användare: $username"

    # Skapa användaren och hemkatalog
    useradd -m "$username"

    # Sätt sökväg till användarens hemkatalog
    home_dir="/home/$username"

    # Skapa mappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Ändra ägare till användaren
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    welcome_file="$home_dir/welcome.txt"

    echo "Välkommen $username" > "$welcome_file"

    echo "" >> "$welcome_file"
    echo "Andra användare i systemet:" >> "$welcome_file"

    # Lista alla användare
    cut -d: -f1 /etc/passwd >> "$welcome_file"

    # Ägaren ska vara användaren
    chown "$username:$username" "$welcome_file"

done

chown -R ...
