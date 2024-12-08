#!/bin/bash 
# Author: robin113x 
# Colorized ASCII art for the beginning of the script 
echo -e "\e[1;31m===================================\e[0m" 
echo -e "\e[1;32m ____ ____ __ \e[0m" 
echo -e "\e[1;33m / __ )____ ____ / __ )____ / /_\e[0m" 
echo -e "\e[1;34m / __ / __ \/ __ \/ __ / __ \/ __/\e[0m" 
echo -e "\e[1;35m/ /_/ / /_/ / /_/ / /_/ / /_/ / /_ \e[0m" 
echo -e "\e[1;36m/_____/\____/\____/_____/\____/\__/ \e[0m" 
echo -e "\e[1;31m=================================== \e[0m" 
echo -e "\e[1;32m============ROBIN H00D============= \e[0m" 
echo -e "\e[1;31m=================================== \e[0m" 
# Global variables
curr_dir=""

# Function to clone the repository
clone_repo() {
  echo "Cloning the repository..."
  git clone https://github.com/robin113x/BurpSuitePro.git
  cd BurpSuitePro
  curr_dir=$(pwd)
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
  cat Version.txt | grep 'professional-community' | head -n 4 | tail -n 1 > latest_version.txt
  LATEST_VERSION=$(cat latest_version.txt | grep -o '[0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}')
  modified=$(echo "$LATEST_VERSION" | sed 's/-/./g')
  echo "Latest version: $modified"

  echo "*********************************************************"
  if [ -f "burpsuite_pro.jar" ]; then
    echo "burpsuite_pro.jar already exists. Skipping download."
  else
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
  fi
  sudo chmod 777 *
}


# Function to check if Java version is less than 21.x.x and install if needed
check_and_install_java() {
  java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  if [[ "$java_version" < "21" ]]; then
    echo "Java version is less than 21, installing the latest Java version..."
    sudo apt update -y && sudo apt install openjdk-21-jdk -y
    if [[ $? -ne 0 ]]; then
      echo "Default installation failed, proceeding with manual installation of OpenLogic OpenJDK 22..."
      sudo apt-get install -y fonts-dejavu  # Ensure dependency is installed
      curl -L -o openlogic.deb https://builds.openlogic.com/downloadJDK/openlogic-openjdk/22.0.2+9/openlogic-openjdk-22.0.2+9-linux-x64-deb.deb
      sudo dpkg -i openlogic.deb
      sudo update-alternatives --config java
    else
      echo "OpenJDK 21 installed successfully."
    fi
  else
    echo "Java version 21.0.x or higher is already installed. Good to go!"
  fi
}



# Function to run keygen and Burp Suite Pro
run_burp_suite() {
  # Run the keygen command in the background
  java -jar keygen.jar > /dev/null &

  # Run Burp Suite Pro in the current terminal
  echo "Starting Burp Suite Pro in the current terminal..."
  /bin/java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:burploader.jar -noverify -jar burpsuite_pro.jar > /dev/null

  echo "Burp Suite Pro is now running in the current terminal."
}

# Function to create a script to run Burp Suite from anywhere
run_from_anywhere() {
  shell=$(echo $0)
  echo "#!/bin/bash" > burp
  echo "cd $curr_dir" >> burp
  echo "  /bin/java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:burploader.jar -noverify -jar burpsuite_pro.jar > /dev/null" >> burp
  sudo chmod 777 burp
  sudo mv burp /bin/
  clear
  
}

# Main script execution
install_git_if_needed
clone_repo
fetch_latest_version
check_and_install_java
run_burp_suite
run_from_anywhere

# Here, the user will choose the Java version to be used
# Prompt the user to select version 22 for Java
clear
echo "Remember to select version 22 when prompted!"
sudo update-alternatives --config java
clear
echo "Type 'burp' in the terminal to run"
