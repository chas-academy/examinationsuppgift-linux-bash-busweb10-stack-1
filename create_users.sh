#!/bin/bash

# =========================================
# Script för att skapa användare
# Skapar mappar och welcome.txt
# =========================================

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste köra scriptet som root!"
    exit 1
fi

# Gå igenom alla användarnamn som skickas in
for username in "$@"
do

    echo "Skapar användare: $username"

    # Skapa användaren och hemkatalog
    useradd -m "$username"

    # Sökväg till hemkatalog
    home_dir="/home/$username"

    # Skapa mappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Ändra ägare
    chown -R "$username:$username" "$home_dir"

    # Skapa welcome.txt
    welcome_file="$home_dir/welcome.txt"

    echo "Välkommen $username" > "$welcome_file"

    echo "" >> "$welcome_file"
    echo "Andra användare i systemet:" >> "$welcome_file"

    # Lista användare från systemet
    cut -d: -f1 /etc/passwd >> "$welcome_file"

    # Sätt rätt ägare
    chown "$username:$username" "$welcome_file"

done

echo "Klart!"
