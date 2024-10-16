#!/bin/bash
#
read -p "Enter your MySQL username: " DB_USER
read -sp "Enter your MySQL password: " DB_PASS
echo ""  
read -p "Enter your MySQL host (e.g., localhost or IP address): " DB_HOST

export DB_NAME="employee_management_system"
cat <<EOL > ~/.my.cnf
[client]
user=$DB_USER
password=$DB_PASS
host=$DB_HOST
EOL

chmod 600 ~/.my.cnf

echo ".my.cnf file created. Your secrets all well protected." 
load_user(){
	
	if [[ -f ~/.my.cnf ]]; then
		echo "Found existing .my.cnf file"

	fi

}




display(){
    echo "--------------------------------"
    echo "Employee Management System"
    echo "--------------------------------"
    echo "1) Edit Employees database"
    echo "2) View Employee details"
    echo "3) "
    echo "4) Exit"
    echo "--------------------------------"
}


###########################################################################
#
##

while true; do
	display
	
	read -p "Chose an option" option

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

echo "Thank you for using our program"







