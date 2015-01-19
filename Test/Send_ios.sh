#!/usr/bin/expect -f

spawn ssh root@[lindex $argv 0] "cd /Applications/; rm -Rf AdColonyOpenFL.app/; exit"
expect "assword:"
send "alpine\r"
interact

spawn scp -rp ./bin/ios/build/Release-iphoneos/AdColonyOpenFL.app/ root@[lindex $argv 0]:/Applications/
expect "assword:"
send "alpine\r"
interact
