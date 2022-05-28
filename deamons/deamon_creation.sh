#!/bin/bash

# set the path where the plist will be created
plistPath="$HOME/Documents/Developer/scripts/deamons/plists";
# path to the script to run 
scriptPath="$HOME/Documents/Developer/scripts/deamons/scripts";
# set the name of the plist
# 

plistName="com.hello.world";
# set the name of the script
scriptName="helloworld.sh";

deamonPath="/Library/LaunchDaemons/$plistName.plist"

pathToSharedScriptsFolder="/Users/Shared/scripts";

newScriptPath="$pathToSharedScriptsFolder/$scriptName";
plistLocation="$plistPath/$plistName.plist";
scriptLocation="$scriptPath/$scriptName"
#  checks if the script exists, if not it creates the file
[ -e $newScriptPath ] && echo "File is here!" || touch $newScriptPath;
#  move the script to the file, ensures any updates are written
mv $scriptLocation $newScriptPath;
#  give script the correct permissions
chmod 644 "$newScriptPath";
sudo chown root:wheel "$newScriptPath";

defaults write $plistLocation  Label $plistName;
defaults write $plistLocation ProgramArguments -array "/bin/bash" "$newScriptPath";
defaults write $plistLocation RunAtLoad -bool yes;
# defaults write $plistLocation StartInterval -int 180
defaults delete $plistLocation StartInterval
#  check to see if a deamon is currently running
if [[ -f $deamonPath ]]; then
sudo launchctl bootout system "$deamonPath"
rm -f "$deamonPath"
fi

[ -e $deamonPath ] && echo "File is here!" || sudo touch $deamonPath;
sudo mv $plistLocation $deamonPath

chmod 644 "$deamonPath";
sudo chown root:wheel "$deamonPath";

sudo launchctl bootstrap system "$deamonPath";
# run to boot out the deamon
# sudo launchctl bootout system/com.hello.world 
echo "$deamonPath"
echo "$plistLocation"

# sudo launchctl list | grep "hello" <- use to see the process since it is not visible unless you run it as sudo