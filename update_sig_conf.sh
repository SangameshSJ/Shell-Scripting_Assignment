#!/bin/bash

# Function to validate component name
validate_component() {
    case "$1" in
        INGESTOR|JOINER|WRANGLER|VALIDATOR) return 0 ;;
        *) echo "Invalid Component Name. Must be one of [INGESTOR, JOINER, WRANGLER, VALIDATOR]." ; return 1 ;;
    esac
}

# Function to validate scale
validate_scale() {
    case "$1" in
        MID|HIGH|LOW) return 0 ;;
        *) echo "Invalid Scale. Must be one of [MID, HIGH, LOW]." ; return 1 ;;
    esac
}

# Function to validate view
validate_view() {
    case "$1" in
        Auction|Bid) return 0 ;;
        *) echo "Invalid View. Must be one of [Auction, Bid]." ; return 1 ;;
    esac
}

# Function to validate count
validate_count() {
    if [[ "$1" =~ ^[0-9]$ ]]; then
        return 0
    else
        echo "Invalid Count. Must be a single digit number (0-9)." 
        return 1
    fi
}

# Read and validate inputs
read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
while ! validate_component "$component"; do
    read -p "Please enter a valid Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
done

read -p "Enter Scale [MID/HIGH/LOW]: " scale
while ! validate_scale "$scale"; do
    read -p "Please enter a valid Scale [MID/HIGH/LOW]: " scale
done

read -p "Enter View [Auction/Bid]: " view
while ! validate_view "$view"; do
    read -p "Please enter a valid View [Auction/Bid]: " view
done

read -p "Enter Count [single digit number]: " count
while ! validate_count "$count"; do
    read -p "Please enter a valid Count [single digit number]: " count
done

if [[ "$view" == "Auction" ]]; then
    vdopiasample="vdopiasample"
else
    vdopiasample="vdopiasample-bid"
fi

new_line="$view ; $scale ; $component ; ETL ; $vdopiasample= $count"

conf_file="sig.conf"
if [ -f "$conf_file" ]; then
    # Use sed to replace the first matching line
    sed -i "0,/;/{s|.*|$new_line|;b}" "$conf_file"
    echo "Configuration updated successfully."
else
    echo "Error: $conf_file not found."
fi
