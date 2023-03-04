#This script will:

# Read the CSV file containg 20 new users to be onboarded

# Create each user on the server, and add to an existing group called developers

# Check for the existence of the user on the system, before it will attempt to create that it.

# create a default home folder fo the user created

# Create a .ssh folder within each created users' HOME folder. If it does not exist, then create it.

# For each user’s SSH configuration, create an authorized_keys file ensure it has the public key of current user


#!/bin/bash
userfile=$(cat names.csv)
PASSWORD=germanyaug

# To ensure the user running this script has sudo privilege
    if [ $(id -u) -eq 0 ]; then

# Reading the CSV file
 for user in $userfile;
 do
            echo $user
        if id "$user" &>/dev/null
        then
            echo "User Exist"
        else

# This will create a new user
        useradd -m -d /home/$user -s /bin/bash -g developers $user
        echo "New User Created"
        echo
# This will create a ssh folder in the user home folder
        su - -c "mkdir ~/.ssh" $user
        echo ".ssh directory created for new user"
        echo

        # We need to set the user permission for the ssh dir
         su - -c "chmod 700 ~/.ssh" $user
         echo "user permission for .ssh directory set"
         echo

# This will create an authorized-key file
        su - -c "touch ~/.ssh/authorized_keys" $user
        echo "Authorized Key File Created"
        echo

# We need to set permission for the key file
        su - -c "chmod 600 ~/.ssh/authorized_keys" $user
        echo "user permission for the Authorized Key File set"
        echo

# We need to create and set public key for users in the server
        cp -R "/home/ubuntu/Shell/id_rsa.pub" "/home/$user/.ssh/authorized_keys"
        echo "Copyied the Public Key to New User Account on the server"
        echo
        echo

        echo "USER HAS BEEN CREATED"

# Generate a password.
sudo echo -e "$PASSWORD\n$PASSWORD" | sudo passwd "$user"
sudo passwd -x 5 $user
            fi
	     done
    else
    echo "Only Admin Can Onboard A User"
    fi

