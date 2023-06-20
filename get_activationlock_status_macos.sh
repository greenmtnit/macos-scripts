#!/bin/bash

# Script Name: get_activationlock_status_macos.sh
#
# Description: Gets the status of Activation Lock on MacOS.
#
# Author: doc
#
# Dependencies: This script requires XYZ package to be installed.
#
# Notes: none
#

# Retrieve the Activation Lock status using system_profiler and awk
activationlock_status=$(/usr/sbin/system_profiler SPHardwareDataType | awk '/Activation Lock Status/{print $NF}')

# Print the Activation Lock status
echo "Activation Lock Status: $activationlock_status"

# Check if Activation Lock is enabled
if [ "$activationlock_status" = "enabled" ]; then
  # If enabled, throw an error and exit
  echo "Activation Lock is enabled!"
  exit 1
fi
