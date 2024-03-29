#!/bin/bash

# Check if the user ID is not 0 (not root)
function check_sudo() {
    if [ "$(id -u)" != 0 ]; then
        echo "Error: This script requires sudo privileges. Please run it with sudo."
        exit 1
    fi
}

# Prints an error message and exits the script
function handle_error() {
    local error_message="$1"
    echo "Error: $error_message"
    exit 1
}

# Executes a command and handles errors
function run() {
    local command="$1"
    local description="$2"

    echo "Executing: $description"

    eval "$command"
    local exit_code=$?

    if [ $exit_code -ne 0 ]; then
        handle_error "Command failed: $description"
    fi
}

# Installs a list of packages
function install_packages() {
    local packages=("$@")

    # Ensure there are packages to install
    if [ ${#packages[@]} -eq 0 ]; then
        handle_error "No packages specified for installation."
    fi

    # Install the specified packages
    run "apt install -y ${packages[*]}" "Installing packages: ${packages[*]}"
}

# Main functions

# Installs the Core Edition packages.
function core() {
    local core_packages=(
        bash 
        wget 
        gnupg
    )

    run "apt update" "updating package lists"

    install_packages "${core_packages[@]}"

    run "wget -qO- https://deb.parrotsec.org/parrot/misc/parrotsec.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/parrot-archive-keyring.gpg" "adding GPG key"

    run "cp config/etc/apt/sources.list /etc/apt/sources.list" "copying sources.list"
    run "cp -r config/etc/apt/sources.list.d/* /etc/apt/sources.list.d" "copying sources.list.d"
    run "cp config/etc/apt/listchanges.conf /etc/apt/listchanges.conf" "copying listchanges.conf"

    run "apt update" "updating package lists"

    run "cp config/etc/os-release /etc/os-release" "copying os-release"
    run "apt update" "updating package lists"
    run "apt upgrade -y" "upgrading packages"

    run "apt install -y parrot-core" "installing parrot-core"

    echo "[!] Core Edition packages installation completed successfully."
}

# Installs the Home Edition packages
function home() {
    local home_packages=(
        parrot-interface-home
        desktop-base
        base-files
        anonsurf
        parrot-drivers
        parrot-menu
        parrot-desktop-mate
        parrot-wallpapers
        parrot-themes
        parrot-displaymanager
        firefox-esr
        parrot-firefox-profiles
        vscodium
    )

    install_packages "${home_packages[@]}"
    echo "[!] Home Edition packages installation completed successfully."
}

# Installs the Security Edition packages
function security() {
    local security_packages=(
        parrot-interface-home
        desktop-base
        base-files
        anonsurf
        parrot-drivers
        parrot-menu
        parrot-desktop-mate
        parrot-wallpapers
        parrot-tools-full
        parrot-themes
        parrot-displaymanager
        firefox-esr
        parrot-firefox-profiles
        vscodium
    )

    install_packages "${security_packages[@]}"
    echo "[!] Security Edition packages installation completed successfully."
}

# Installs the HTB Edition packages
function htb() {
    local htb_packages=(
        parrot-interface-home
        desktop-base
        base-files
        anonsurf
        parrot-drivers
        parrot-menu
        parrot-desktop-mate
        parrot-wallpapers
        parrot-tools-full
        parrot-themes
        parrot-displaymanager
        hackthebox-icon-theme
        win10-icon-theme
        firefox-esr
        parrot-firefox-profiles
        vscodium
    )

    install_packages "${htb_packages[@]}"
    echo "[!] Hack The Box Edition packages installation completed successfully."
}

# Installs the headless edition packages
function headless() {
    local headless_packages=(
        parrot-core-lite
        base-files
        parrot-apps-basics
        parrot-drivers
    )

    install_packages "${headless_packages[@]}"
    echo "[!] Headless installation completed successfully."
}

function display_menu() {
    echo "========== ParrotOS Editions Installer =========="
    echo "1) Install Core Edition"
    echo "2) Install Home Edition"
    echo "3) Install Security Edition"
    echo "4) Install Hack The Box Edition"
    echo "5) Install headless packages"
    echo "6) Exit"
    echo "================================================="
}

check_sudo
while true; do
    display_menu

    read -p "Enter the option number: " option

    case $option in
        1) core ;;
        2) home ;;
        3) security ;;
        4) htb ;;
        5) headless ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
