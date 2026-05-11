#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra detta script."
    exit 1
fi
# Kontrollera att minst ett användarnamn skickats med
if [ $# -eq 0 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Loopa igenom alla användarnamn som skickas in
for USERNAME in "$@"
do
    # Skapa användaren med hemkatalog
    useradd -m "$USERNAME"

    echo "Användaren $USERNAME har skapats."
done
    # Skapa mappar i användarens hemkatalog
    mkdir -p /home/$USERNAME/Documents
    mkdir -p /home/$USERNAME/Downloads
    mkdir -p /home/$USERNAME/Work

    # Ge rätt ägare till mapparna
    chown -R $USERNAME:$USERNAME /home/$USERNAME

    # Sätt rättigheter så bara ägaren kan läsa/skriva
    chmod 700 /home/$USERNAME/Documents
    chmod 700 /home/$USERNAME/Downloads
    chmod 700 /home/$USERNAME/Work
        # Skapa welcome.txt i användarens hemkatalog
    {
        echo "Välkommen $USERNAME"
        echo ""
        echo "Andra användare i systemet:"
        
        # Lista alla andra användare
        cut -d: -f1 /etc/passwd | grep -v "^$USERNAME$"
    } > /home/$USERNAME/welcome.txt

    # Sätt rätt ägare och rättigheter på filen
    chown $USERNAME:$USERNAME /home/$USERNAME/welcome.txt
    chmod 600 /home/$USERNAME/welcome.txt
done
