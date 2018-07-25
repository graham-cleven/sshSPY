oldSessions=`cat SSHsessions`
sessions=`ps -elf | tr -s ' ' | cut -d " " -f 4,15 | grep sshd | grep -v '/sbin' | cut -d " " -f 1`
echo "$sessions" > SSHsessions

sessions=`diff <(echo "$sessions") <(echo "$oldSessions") --suppress-common-lines`
if [ `echo $sessions | wc -c` == 1 ]; then
	exit; fi;

if [ `echo "$sessions" | grep '>' | wc -c` == 0 ]; then
	PID=`tail -1 SSHsessions`
	echo "new connection with PID of $PID" 
fi;

strace -p $PID 2> strace &

tail -f strace

