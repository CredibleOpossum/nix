#!/usr/bin/env bash

set -e

echo "WARNING: By default this will attempt to install to the drive specified by disko_config.nix, also wiping all data on that disk (if it exists). Make sure this device has no filesystem."
echo "You can change this by changing the device specified in the file."
read -p "Are you sure you want to continue with the install? [y/N]: "
echo
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    # Partition device, dangerous.
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko_config.nix
    
    # Generate config without filesystem as it was already done by disko.
    sudo nixos-generate-config --no-filesystems --root /mnt
    
    # Move configs
    sudo cp * /mnt/etc/nixos
    
    # Install nixos
    sudo nixos-install --root /mnt --flake '/mnt/etc/nixos#nixos'
    
    echo "Script ended without errors, feel free to reboot and test the installation."
fi

