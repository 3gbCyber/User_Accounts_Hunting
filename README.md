# User Accounts Hunting

The Script helps you to know all users that has a folder in /home/ and give you some user info
Like:

1- Created Time
2- Last Change Password
3- Last Login
4- User Status
5- UID
6- GID
7- Has Password?
8- Sudo Access
9- etc/passwd
10- etc/shadow

These informations are values especially when you work as DFIR.

Usage:

``` sudo bash user.sh > result.csv ```

Example of the result: 

![Result](https://i.ibb.co/DMkmXQn/User-Account-Hunting-v2.png)

NOTE: If you see the last user Khalid has no info which means the user is deleted but its folder is still there in /home/

