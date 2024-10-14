#!/bin/bash
#
DB_USER="name"
DB_PASS="pass"
DB_NAME="name"
DB_HOST="host"

message=""

display_employees(){
	echo "Employee list"
	#TO DO MAKE IT WORK WITH DB IN QUESTION
	#mysql -u "$DB_USER" -p "$DB_PASS" -D "$DB_NAME" -e "SELECT id,name FROM employees;" 
	read -n 1 -s -r -p "Press any key to exit..."

}
add_employee(){
	echo "Creating new employee"
	read -p "Enter employee Name: " name
	read -p "Enter Employee position: " position
	read -p "Enter Employee Department: " department
	read -p "Enter Employee Salary: " salary

	    #mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "INSERT INTO employees (name, position, department, salary) VALUES ('$name', '$position', '$department', '$salary');"
	echo "INSERT INTO employees (name, position, department, salary) VALUES ('$name', '$position', '$department', '$salary');"
	read -n 1 -s -r -p "Press any key to exit..."
}	

show_menu() {
	clear
	
	echo "M       M   TTTTTTT  H     H  RRRR    EEEEE    EEEEE"
	echo "MM     MM      T     H     H  R   R   E        E    "
	echo "M M   M M      T     HHHHHHH  RRRR    EEEE     EEEE "
	echo "M  M M  M      T     H     H  R R     E        E    "
	echo "M   M   M      T     H     H  R  RR   EEEEE    EEEEE"
	echo "----------------------------------------------------"
	echo "EEEEE   M       M  PPPP  M       M   AAAAA   N     N "
	echo "E       MM     MM  P   P MM     MM  A     A  NN    N "
	echo "EEEE    M M   M M  PPPP  M M   M M  AAAAAAA  N N   N "
	echo "E       M  M M  M  P     M  M M  M  A     A  N  N  N "
	echo "EEEEE   M   M   M  P     M   M   M  A     A  N   N N "
	echo
	echo
	echo

	echo "Choose an option"
	echo "1. Read all employees data"
	echo "2. Add a new eployee"
	echo "3. Edit employee"
	echo "4. Remove employee"
	echo "6. Exit"
	echo
	echo
	echo "$message"
}


######################################################
#############PROGRAM##################################
######################################################


while true; do
	show_menu
	read -p "enter your command: " choice 

	case $choice in
		1) 
			display_employees;;
		2)
			add_employee;;
		3)
			message="update dummy";;
		4)
			message="delete dummy";;
		5)
			echo "exciting"
			break;;
		*) message="Invalid option"
	esac
done









