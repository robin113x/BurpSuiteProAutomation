@echo off
set JAVA_PATH="C:\Program Files\Java\jdk-23\bin\java.exe"
set BURPLOADER="C:\Users\Robin\Documents\Tools&VMS\BurpSuitePro\burploader.jar"
set BURP_JAR="C:\Users\Robin\Documents\Tools&VMS\BurpSuitePro\burpsuite_pro_v2025.3.3.jar"

%JAVA_PATH% ^
  "--add-opens=java.desktop/javax.swing=ALL-UNNAMED" ^
  "--add-opens=java.base/java.lang=ALL-UNNAMED" ^
  "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED" ^
  "--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED" ^
  "--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED" ^
  -javaagent:%BURPLOADER% ^
  -noverify ^
  -jar %BURP_JAR%
pause
