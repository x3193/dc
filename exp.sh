#/usr/bin/expect -f

# run the application
spawn su -
expect -exact "password:"
send "EUIfgwe7\r"
expect "\$ "
send "sh /run.sh\r"             
expect "\$ "
sleep 5
interact
