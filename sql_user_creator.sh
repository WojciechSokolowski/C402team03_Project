#!/bin/bash
#
can_create=false
msg=""
create_mysql_user() {

    user=$1


    read -p "Enter the username for the new MySQL user: " new_user
    read -sp "Enter the password for the new MySQL user: " new_password
    echo ""
    read -p "Enter the host (e.g., 'localhost' or '%'): " host

    case "$user" in
        "admin")
            mysql -e "CREATE USER '$new_user'@'$host' IDENTIFIED BY '$new_password';"
            mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$new_user'@'$host' WITH GRANT OPTION;"
            echo "Admin user '$new_user' created with all privileges."
            ;;
        "manager")
            mysql -e "CREATE USER '$new_user'@'$host' IDENTIFIED BY '$new_password';"
            mysql -e "GRANT ALL PRIVILEGES ON employee_management_system.* TO '$new_user'@'$host';"
            echo "Manager user '$new_user' created with access to the employee_management_system database."
            ;;
        "employee")
            mysql -e "CREATE USER '$new_user'@'$host' IDENTIFIED BY '$new_password';"
            mysql -e "GRANT SELECT ON employee_management_system.* TO '$new_user'@'$host';"
            echo "Employee user '$new_user' created with read-only access to the employee_management_system database."
            ;;
        *)
            echo "Invalid user type. User creation failed."
            return 1
            ;;
    esac

    # Flush privileges
    mysql -e "FLUSH PRIVILEGES;"


}

check_user_creation_privileges() {
    if mysql -e "CREATE USER 'test_user'@'%' IDENTIFIED BY 'test_password';" &> /dev/null; then
        mysql -e "DROP USER 'test_user'@'%';"
	can_create=true
    else
        echo "You do not have sufficient privileges to create users in MySQL."
	can_create=false
    	read -n 1 -s -r -p "Press any key to exit..."
    fi
}

describe(){

	echo "This program allows us to create MYSQL USERS"
	echo "We defined 3 categories of users in our company"
	echo "Admin has all privileges and can grant them on other accounts"
	echo "Manager can do every operation on our database but can not grant this privileges onto other"
	echo "Employye has just SELECT option, they can just view the data"
	read -n 1 -s -r -p "Press any key to exit..."
}
show_users() {
    	mysql -e "SELECT User, Host FROM mysql.user;"
    	read -n 1 -s -r -p "Press any key to continue..."
}

drop_user() {
    
    	read -p "Enter the username of the MySQL user to drop: " user_to_drop
    	read -p "Enter the host for the user (e.g., 'localhost' or '%'): " host

    	read -p "Are you sure you want to drop the user '$user_to_drop'@$host? (y/n): " confirmation

    	if [[ "$confirmation" == "y" || "$confirmation" == "Y" || "$confirmation" == "yes" ]]; then
        	mysql -e "DROP USER '$user_to_drop'@'$host';" 2>/dev/null

        	if [ $? -eq 0 ]; then
            		echo "User '$user_to_drop'@$host has been successfully dropped."
        	else
            		echo "Error: Could not drop user '$user_to_drop'@$host. Make sure the user exists and you have the necessary permissions."
        	fi
    	else
        	echo "User drop cancelled."
    	fi

    	read -n 1 -s -r -p "Press any key to continue..."
}


check_user_creation_privileges
while [[ $can_create == true ]];do
	
	clear
	echo "Select user type to create:"
    	echo "1) Admin"
    	echo "2) Manager"
    	echo "3) Employee"
	echo "Select other options:"
    	echo "4) Describe"
	echo "5) show all users"
    	echo "6) Drop user"
	echo "7) Exit"
	echo
	echo
	echo "$msg"


	read -p "Enter command: " user_type

	case $user_type in
		1)
			create_mysql_user "admin"
			;;
		2)
			create_mysql_user "manager"
			;;
		3)
			create_mysql_user "employee"
			;;
		4)
			describe
			;;
		5)
			show_users
			;;
		6)
			drop_user
			;;
		7)	echo "Exiting"
			break
			;;
		*)
			msg= "Invalid option"
			;;
	esac
done
			
