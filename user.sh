#! /bin/bash

IFS=$'\n'

#ForRoot

echo User, Created Time, Password Last Changed, Last Login, User Status, UID, GID, Has Password, Sudo Access, Passwd


                createdroot=`sudo ls -alct / | tail -1 | awk '{print $6 ,$7, $8}'`
                rootpasschanged=`passwd -S root | awk '{print $3}'`
                rootid=`id -u root`
                rootgroupid=`id -g root`
                rootetcpasswd=`echo '"'$(sudo grep root /etc/passwd 2>/dev/null)'"'`

                rootlastlogin=`last root | grep root | head -n 1 | awk '{print $5,$6,$7,$8,$9,$10,$11,$12}' 2>/dev/null`
                rootsudo=`echo "I'm the sudo"`

                rootstatus=`if [[ $(cat /etc/shadow | grep root | grep ':!:' 2>/dev/null) ]]; then echo "Disable"; else echo "Enable"; fi`
                roothaspass=`if [[ $(cat /etc/shadow | grep root | grep '*' 2>/dev/null) ]]; then echo "False"; else echo "True";fi`


                echo "root, $createdroot, $rootpasschanged, $rootlastlogin, $rootstatus, $rootid, $rootgroupid, $roothaspass, $rootsudo, $rootetcpasswd"


#ForAllUsers

os=`cat /etc/os-release | grep -E -o "CentOS |Red Hat" | head -n 1`

if [[ "$os" == "CentOS" || "$os" == "Red Hat" ]]

then


                for user in $(ls /home)
                do

                                        createduser=`grep "adduser $user" /var/log/secur* | grep -v "grep" | grep -v "zgrep" | sed 's/\(:\)\([A-Za-z]\{3\}\)[[:space:]]/\ \2 /g' | awk '{print $2,$3,$4}' 2>/dev/null`
                                        
                                        userid=`id -u $user 2>/dev/null`
                                        groupid=`id -g $user 2>/dev/null`
                                        etcpasswd=`echo '"'$(sudo grep $user /etc/passwd 2>/dev/null)'"'`
                                        

                                        lastlogin=`last $user | head -n 1 | awk '{print $5,$6,$7,$8,$9,$10,$11,$12}' 2>/dev/null`
                                        userpasschanged=`passwd -S $user | awk '{print $3}' 2>/dev/null`
                                        usersudo=`sudo -l -U $user | tail -n1`

                                        userstatus=`if [[ $(cat /etc/shadow | grep $user | grep ':!:' 2>/dev/null) ]]; then echo "Disable"; else echo "Enable"; fi`
                                        haspass=`if [[ $(cat /etc/shadow | grep $user | grep '*' 2>/dev/null) ]]; then echo "False"; else echo "True";fi`

                                        createduser2=`if [[ $(id -u $user) == "1000" ]]; then echo $createdroot ; fi`

                      		        echo "$user, $createduser$createduser2, $userpasschanged, $lastlogin, $userstatus, $userid, $groupid, $haspass, $usersudo, $etcpasswd"
                                                
                                        
                						
                done

else

                for user in $(ls /home)
                do

                                        createduser=`zgrep "adduser $user" /var/log/auth.log.*.gz | grep -v "grep" | grep -v "zgrep" | sed 's/\(:\)\([A-Za-z]\{3\}\)[[:space:]]/\ \2 /g' | awk '{print $2,$3,$4}' 2>/dev/null`
                                        createduser2=`grep "adduser $user" /var/log/auth.* |  grep -v "grep" | grep -v "zgrep" | sed 's/\(:\)\([A-Za-z]\{3\}\)[[:space:]]/\ \2 /g' | awk '{print $2,$3,$4}' 2>/dev/null`
                                        
                                        userid=`id -u $user 2>/dev/null`
                                        groupid=`id -g $user 2>/dev/null`
                                        etcpasswd=`echo '"'$(sudo grep $user /etc/passwd 2>/dev/null)'"'`
                                        

                                        lastlogin=`last $user | head -n 1 | awk '{print $5,$6,$7,$8,$9,$10,$11,$12}' 2>/dev/null`
                                        userpasschanged=`passwd -S $user | awk '{print $3}' 2>/dev/null`
                                        usersudo=`sudo -l -U $user | tail -n1`

                                        userstatus=`if [[ $(cat /etc/shadow | grep $user | grep ':!:' 2>/dev/null) ]]; then echo "Disable"; else echo "Enable"; fi`
                                        haspass=`if [[ $(cat /etc/shadow | grep $user | grep '*' 2>/dev/null) ]]; then echo "False"; else echo "True";fi`

                                        createduser3=`if [[ $(id -u $user) == "1000" ]]; then echo $createdroot ; fi`

                                        echo "$user, $createduser$createduser2$createduser3, $userpasschanged, $lastlogin, $userstatus, $userid, $groupid, $haspass, $usersudo, $etcpasswd"
                                                
                                        
                                                                
                done




fi
