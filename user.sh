#! /bin/bash

#ForRoot

echo User, Created Time, Password Last Changed, Last Login, User Status, UID, GID, Has Password, Sudo Access, Passwd

createdroot=`sudo ls -alct / | tail -1 | awk '{print $6 ,$7, $8}'`
rootpasschanged=`passwd -S root | awk '{print $3}'`
rootid=`id -u root`
rootgroupid=`id -g root`
rootetcpasswd=`echo '"'$(sudo grep root /etc/passwd 2>/dev/null)'"'`

rootlastlogin=`last root | grep root`
rootsudo=`echo "I'm the sudo"`

rootstatus=`if [[ $(passwd --status root | awk '{print $2}') == "P" ]]; then echo "Enable"; else echo "Disable"; fi`
roothaspass=`if [[ $(cat /etc/shadow | grep root | grep '/' 2>/dev/null) ]]; then echo "True"; else echo "False";fi`


echo "root, $createdroot, $rootpasschanged, $rootlastlogin, $rootstatus, $rootid, $rootgroupid, $roothaspass, $rootsudo, $rootetcpasswd"

#ForAllUsers

for user in $(ls /home)
do
	bash_logout=`ls -a /home/$user/.bash_logout 2>/dev/null`

                for file in $(echo $bash_logout)
                do

                        for createduser in $(stat $file | grep Change | awk '{print $2}' | sed -E 's,([0-9]{4})-([0-9]{2})-([0-9]{2}),\2/\3/\1,g')
                        do
                        	userid=`id -u $user 2>/dev/null`
                        	groupid=`id -g $user 2>/dev/null`
                        	etcpasswd=`echo '"'$(sudo grep $user /etc/passwd 2>/dev/null)'"'`
                        	
                        	lastlogin=`last $user | head -n 1 | awk '{print $5,$6,$7,$8,$9,$10,$11,$12}' 2>/dev/null`
                                userpasschanged=`passwd -S $user | awk '{print $3}' 2>/dev/null`
                                usersudo=`sudo -l -U $user | tail -n1`

                                userstatus=`if [[ $(passwd --status $user | awk '{print $2}') == "P" ]]; then echo "Enable"; else echo "Disable"; fi`
                                haspass=`if [[ $(cat /etc/shadow | grep $user | grep '/' 2>/dev/null) ]]; then echo "True"; else echo "False";fi`


      		                echo "$user, $createduser, $userpasschanged, $lastlogin, $userstatus, $userid, $groupid, $haspass, $usersudo, $etcpasswd"
                                
                        done
                done
done
