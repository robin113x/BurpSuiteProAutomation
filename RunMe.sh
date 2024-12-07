#!/bin/bash

# Author: robin113x

# ASCII art for the beginning of the script
echo "==================================="
echo "   ____              ____        __ "
echo "  / __ )____  ____  / __ )____  / /_"
echo " / __  / __ \/ __ \/ __  / __ \/ __/"
echo "/ /_/ / /_/ / /_/ / /_/ / /_/ / /_  "
echo "/_____/\____/\____/_____/\____/\__/  "
echo "=================================== "
echo "============ROBIN H00D============= "
echo "=================================== "

# Global variables
LATEST_VERSION=""
modified=""

# Function to clone the repository
clone_repo() {
  echo "Cloning the repository..."
  git clone https://github.com/robin113x/Burp-Suite.git
  cd Burp-Suite
  ls
}

# Function to install Git if not found
install_git_if_needed() {
  if ! command -v git &> /dev/null; then
    echo "Git not found, installing it..."
    sudo apt-get install -y git
  else
    echo "Git is already installed."
  fi
}

# Function to fetch the latest Burp Suite Pro version
fetch_latest_version() {
  echo "Fetching the latest Burp Suite Pro version..."
  curl -s https://portswigger.net/burp/releases#professional > Version.txt
  cat Version.txt | grep 'professional-community' | head -n 1 > latest_version.txt
  LATEST_VERSION=$(cat latest_version.txt | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}')
  modified=$(echo "$LATEST_VERSION" | sed 's/-/./g')
  echo "Latest version: $modified"
}

# Function to download Burp Suite Pro
download_burp_suite() {
  echo "Downloading Burp Suite Pro version $modified..."
  DOWNLOAD_URL="https://portswigger-cdn.net/burp/releases/download?product=pro&version=${modified}&type=Jar"
  echo $DOWNLOAD_URL
  curl -L -o "burpsuite_pro.jar" "$DOWNLOAD_URL"

  if [ -f "burpsuite_pro.jar" ]; then
    echo "Download complete: burpsuite_pro.jar"
  else
    echo "Download failed. Please check the URL and your network connection."
    exit 1
  fi
  sudo chmod 777 *
}

# Function to check if Java version is less than 21.x.x and install if needed
check_and_install_java() {
  java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  if [[ "$java_version" < "21" ]]; then
    echo "Java version is less than 21, installing the latest Java version..."
    curl -L -o openjdk.deb https://builds.openlogic.com/downloadJDK/openlogic-openjdk/22.0.2+9/openlogic-openjdk-22.0.2+9-linux-x64-deb.deb
    sudo dpkg -i openjdk.deb
  else
    echo "Java version 21.0.x or higher is already installed. Good to go!"
  fi
}

# Function to install xterm if not already installed
install_xterm_if_needed() {
  if ! command -v xterm &> /dev/null; then
    echo "xterm not found, installing it..."
    sudo apt-get install -y xterm
  else
    echo "xterm is already installed."
  fi
}

# Function to run keygen and Burp Suite Pro
run_burp_suite() {
  # Run the keygen command in the background
  java -jar keygen.jar > /dev/null &

  # Run Burp Suite Pro in the current terminal
  echo "Starting Burp Suite Pro in the current terminal..."
  /usr/lib/jvm/jdk-21.0.5-oracle-x64/bin/java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:burploader.jar -noverify -jar burpsuite_pro.jar

  echo "Burp Suite Pro is now running in the current terminal."
}

# Main script execution
install_git_if_needed
clone_repo
fetch_latest_version
download_burp_suite
check_and_install_java
install_xterm_if_needed
run_burp_suite
