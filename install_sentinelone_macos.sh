#!/bin/bash

# Script Name: install_sentinelone_macos.sh
#
# Description: Install SentinelOne on MacOS.
#
# Author: doc
#
# Notes: You must get the SentinelOne token for the site from the SentinelOne console.
# You must also download the SentinelOne .pkg install and host it somewhere.
# If using Mosyle MDM, you can use the Mosyle CDN and then pass the name as a variable.
# You must also assign permissions (manually or through MDM) to make SentinelOne full active.

#Specify log file
logfile="tmp/sentineloneinstall.log"

# Redirect both stdout and stderr to the log file
exec > "$logfile" 2>&1

#Your SentinelOne token goes here
sentinel_token="YOURTOKENHERE="
#Your download link goes here
download_link="YOUR_DOWNLOAD_LINK_HERE"
#Use this for download_link instead if using Mosyle
#download_link="%MosyleCDNFile:MOSYLE_UUID_HERE%"
#Your package name goes here
pkg_name="Sentinel.pkg"

# Check if SentinelOne is already installed
if [[ -d "/Applications/SentinelOne/" ]]; then
  echo "SentinelOne is already installed."
  exit 0
else
  # Download Agent
  curl -L -o "/tmp/$pkg_name" "$download_link"

  # Set Token
  echo "$sentinel_token" > "/tmp/com.sentinelone.registration-token"

  # Install Agent
  /usr/sbin/installer -pkg /tmp/$pkg_name -target "/"

  # Clean up temporary files
  rm "/tmp/$pkg_name" "/tmp/com.sentinelone.registration-token"
fi
