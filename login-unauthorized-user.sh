#!/bin/bash
# Get currently logged in users and filter out users that don't start with 'ri', 'pc', 'zur', or 'ttr'
LOGGED_IN_USERS=$(who | awk '{print $1, $3, $4}' | grep -Ev "^(ri|pc|zur|ttr)")

# If there are unauthorized users, output them in a proper format
echo > user
if [[ ! -z "$LOGGED_IN_USERS" ]]; then
    # Print unauthorized users with login date and time
   # echo "Unauthorized SSH login attempts by users:"
    echo "$LOGGED_IN_USERS" | while read user date time zone; do
    #echo " User: $user | Date: $date | Time: $time $zone" >> user
    echo " User: $user | Date: $date | Time: $time $zone"
# echo  $user $date $time $zone
    done
    exit 1
else
    echo "No unauthorized users logged in."
    exit 0
fi
