#!/bin/bash

# Script Name: install_sentinelone_macos.sh
#
# Description: Install SyncroMSP agent on macOS.
#
# Author: doc
#

# Paste in your Syncro policy ID token.
# Get this from the Syncro MacOS RMM installer link - copy the token from the end of the URL.
# See here for documentation, https://community.syncromsp.com/t/syncro-mac-agent/1591#script_deploy
POLICY_ID="abcdefgh-ijkl-mnop-qrst-uvwzyx123456"

# Paste in your full URL to the Syncro MacOS installer for the customer.
# Find this on the Syncro Customer page > Assets & Policies > New > RMM Agent Installer > Mac (PKG) and copy the link
SYNCRO_URL="https://production.kabutoservices.com/desktop/macos/setup?token=abcdefgh-ijkl-mnop-qrst-uvwzyx123456"

# Define file paths
syncro_deploy_id="/tmp/syncro-deploy-id"
syncro_pkg="/tmp/SyncroDesktop.pkg"

# Check if Syncro is already installed
if [ -f "/usr/local/bin/syncro" ]; then
  echo "Syncro is already installed."
  exit 0
fi

# Run the install

# On M1 Macs, we need to install Rosetta - https://support.apple.com/en-us/HT211861
# Function to install Rosetta
install_rosetta() {
  # Determine the architecture of the macOS device
  processorBrand=$(/usr/sbin/sysctl -n machdep.cpu.brand_string)
  if [[ "${processorBrand}" = *"Apple"* ]]; then
    echo "Apple Processor is present."
  else
    echo "Apple Processor is not present. Rosetta not required."
    return
  fi

  # Check if Rosetta is installed
  checkRosettaStatus=$(/bin/launchctl list | /usr/bin/grep "com.apple.oahd-root-helper")
  RosettaFolder="/Library/Apple/usr/share/rosetta"
  if [[ -e "${RosettaFolder}" && "${checkRosettaStatus}" != "" ]]; then
    echo "Rosetta Folder exists and Rosetta Service is running. Exiting..."
    return
  else
    echo "Rosetta Folder does not exist or Rosetta service is not running. Installing Rosetta..."
  fi

  # Install Rosetta
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license

  # Check the result of Rosetta install command
  if [[ $? -eq 0 ]]; then
    echo "Rosetta installed successfully."
  else
    echo "Rosetta installation failed."
    exit 1
  fi
}

# Function to install the Syncro agent.
install_syncro_agent() {
  # Write the Syncro policy ID to a file.
  echo "$POLICY_ID" > "$syncro_deploy_id"

  # Download the Syncro package using curl.
  /usr/bin/curl -L1 "$SYNCRO_URL" -o "$syncro_pkg"

  # Install the SyncroDesktop package using the installer command.
  /usr/sbin/installer -target / -pkg "$syncro_pkg"

  # Remove the downloaded package and the policy ID file using the rm command.
  # The -f flag prevents error messages if the files don't exist.
  /bin/rm -f "$syncro_pkg"
  /bin/rm -f "$syncro_deploy_id"

  # Print a message indicating that the Syncro agent is installed.
  echo "Syncro Agent Installed!"
}

# Invoke the function to install the Syncro agent.
install_rosetta
install_syncro_agent
