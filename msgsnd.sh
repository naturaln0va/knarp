#!/bin/bash

INTERVAL=180
SOUND="/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Note.m4r"
FILE="$HOME/Library/Scripts/msg.sh"

/bin/cat <<EOM >$FILE
#!/bin/bash

osascript <<EOD
tell application "System Events"	
	set vol to output volume of (get volume settings)
	set volume output volume 10
	
	display notification "Hey there" with title "From Your Mom"
	do shell script "afplay -r 1 $SOUND > /dev/null 2>&1 &"
	
	set volume output volume vol
end tell
EOD
EOM

chmod 755 $FILE

PLIST="com.apple.system.knarp.plist"
DAEMON="$HOME/Library/LaunchAgents/$PLIST"

/bin/cat <<EOM >$DAEMON
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>$PLIST</string>
	<key>ProgramArguments</key>
	<array>
		<string>$FILE</string>
	</array>
	<key>StartInterval</key>
	<integer>$INTERVAL</integer>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
EOM

launchctl load -w $DAEMON
touch -t 201808131122 $DAEMON

rm -- "$0"