#!/bin/bash

export DB_NAME="employee_management_system"

echo ".my.cnf file created. Your secrets all well protected." 
load_user(){
	
	if [[ -f ~/.my.cnf ]]; then
		echo "Found existing .my.cnf file"
		DB_USER=$(grep "^user" ~/.my.cnf | awk -F'=' '{print $2}' | tr -d ' ')
        	echo "Stored MySQL Username: $DB_USER"
		read -p "Do you want to use the existing credentials? (yes/no): " use_existing

		if [[ "$use_existing" == "yes" ]]; then
           		echo "Using credentials from .my.cnf."
		else
			create_user
		fi
	else
		create_user
	fi

}

create_user(){

echo "Creating a new .my.cnf file."
read -p "Enter your MySQL username: " DB_USER
read -sp "Enter your MySQL password: " DB_PASS
echo ""  
read -p "Enter your MySQL host (e.g., localhost or IP address): " DB_HOST

cat <<EOL > ~/.my.cnf
[client]
user=$DB_USER
password=$DB_PASS
host=$DB_HOST
EOL

chmod 600 ~/.my.cnf
echo ".my.cnf file created."
}

check_user(){
    if mysql -e "SELECT 1;" &> /dev/null; then
        echo "MySQL credentials are valid."
    else
        echo "Invalid MySQL credentials or unable to connect to MySQL."
        exit 1
    fi

}

delete_user(){
    if [[ -f ~/.my.cnf ]]; then
        read -p "Do you want to delete the .my.cnf file? (yes/no): " delete_file
        if [[ "$delete_file" == "yes" ]]; then
            rm ~/.my.cnf
            echo ".my.cnf file deleted."
        else
            echo "Keeping .my.cnf file."
        fi
    else
        echo "No .my.cnf file to delete."
    fi
}


display(){
    echo "--------------------------------"
    echo "Employee Management System"
    echo "--------------------------------"
    echo "1) Edit Employees database"
    echo "2) View Employee details"
    echo "3) "
    echo "4) "
    echo "5) "
    echo "6) "

    echo "9) Exit"
    echo "--------------------------------"
}


###########################################################################
#
##

load_user
check_user



while true; do
	display
	
	read -p "Chose an option: " option

	case $option in
		1)
			./employee_viewer.sh 
			;;
		2)
			./view_employee.sh
			;;
		9) break
			;;
		*) echo "Invalid option please choose one from the system."
			;;
	esac
done

delete_user
echo "Thank you for using our program"







