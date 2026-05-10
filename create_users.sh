#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste köra scriptet som root!"
    exit 1
fi

# Kontrollera att minst ett användarnamn skickas in
if [ $# -eq 0 ]; then
    echo "Ange minst ett användarnamn"
    exit 1
fi

# Loop genom alla användare
for username in "$@"
do
    # Skapa användare
    useradd -m "$username"

    home="/home/$username"

    # Skapa mappar
    mkdir -p "$home/Documents"
    mkdir -p "$home/Downloads"
    mkdir -p "$home/Work"

    # Sätt rättigheter (endast ägare)
    chmod 700 "$home/Documents"
    chmod 700 "$home/Downloads"
    chmod 700 "$home/Work"

    # Se till att användaren äger allt
    chown -R "$username:$username" "$home"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        echo ""
        echo "Andra användare i systemet:"
        cut -d: -f1 /etc/passwd
    } > "$home/welcome.txt"

    chown "$username:$username" "$home/welcome.txt"

done
