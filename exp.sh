#/usr/bin/expect -f

# run the application
set timeout 5
spawn su -
expect -exact "password:"
send "EUIfgwe7\r"
expect "#"
send "sh /run.sh\r"             
expect "#"
send "echo $?\r"
sleep 5
interact
