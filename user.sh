#! /bin/bash

#ForRoot

echo User, Created Time, Password Last Changed, Last Login, UID, GID, Passwd, Shadow

createdroot=`sudo ls -alct / | tail -1 | awk '{print $6 ,$7, $8}'`
rootpasschanged=`passwd -S root | awk '{print $3}'`
rootid=`id -u root`
rootgroupid=`id -g root`
rootetcpasswd=`sudo grep root:x /etc/passwd | sed -r 's/[,]+/./g'`
rootetcshadow=`sudo grep root /etc/shadow | sed -r 's/[,]+/./g'`
rootlastlogin=`last root | grep root`


echo "root, $createdroot, $rootpasschanged, $rootlastlogin, $rootid, $rootgroupid, $rootetcpasswd, $rootetcshadow"

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
                        	etcpasswd=`sudo grep $user:x /etc/passwd | sed -r 's/[,]+/./g' 2>/dev/null`
                        	etcshadow=`sudo grep $user /etc/shadow | sed -r 's/[,]+/./g' 2>/dev/null`
                        	lastlogin=`last $user | head -n 1 | awk '{print $5,$6,$7,$8,$9,$10,$11,$12}' 2>/dev/null`
                        	
                                userpasschanged=`passwd -S $user | awk '{print $3}' 2>/dev/null`

      		                echo "$user, $createduser, $userpasschanged, $lastlogin, $userid, $groupid, $etcpasswd, $etcshadow"
                                
                        done
                done
done
