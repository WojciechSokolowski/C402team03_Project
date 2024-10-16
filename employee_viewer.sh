#!/bin/bash
#
read -p "Enter MySQL username: " DB_USER
read -sp "Enter MySQL password: " DB_PASS
echo    # To move to a new line after the password input
DB_NAME="employee_management_system"
read -p "Enter host (e.g., your-ec2-ip): " DB_HOST


message=""

display_employees(){
	echo "Employee list"
	#TO DO MAKE IT WORK WITH DB IN QUESTION
	mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "SELECT employee_id AS 'ID', CONCAT(first_name, ' ', last_name) AS 'Name' FROM employee;" | column -t -s $'\t'
    
    	echo ""
    	read -n 1 -s -r -p "Press any key to continue..."

}
add_employee(){
	echo "Creating new employee"
    	read -p "Enter first name: " first_name
    	read -p "Enter last name: " last_name
    	read -p "Enter date of birth (YYYY-MM-DD): " date_of_birth
    	read -p "Enter email: " email
   	read -p "Enter mobile number: " mobile
    	read -p "Enter location ID: " location_id
	mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "INSERT INTO employee (first_name, last_name, date_of_birth, email, mobile, location_id) VALUES ('$first_name', '$last_name', '$date_of_birth', '$email', '$mobile', '$location_id');"
	echo "INSERT INTO employee (first_name, last_name, date_of_birth, email, mobile, location_id) VALUES ('$first_name', '$last_name', '$date_of_birth', '$email', '$mobile', '$location_id');"
	read -n 1 -s -r -p "Press any key to exit..."
}

edit_employee(){

	read -p "Enter the employee ID to edit: " employee_id

	    employee=$(mysql -h "$DB_HOST"  -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -se "SELECT first_name, last_name, date_of_birth, email, mobile, location_id FROM employee WHERE employee_id='$employee_id';")
	if [ -z "$employee" ]; then
		message="No employee found with ID $employee_id"
		return
	fi
	    
	IFS=$'\t' read -r current_first_name current_last_name current_dob current_email current_mobile current_location_id <<< "$employee"

	echo "Press enter to NOT edit each data"
    	read -p "First Name [$current_first_name]: " first_name
    	if [ -z "$first_name" ]; then
        	first_name="$current_first_name"
    	fi

    	read -p "Last Name [$current_last_name]: " last_name
    	if [ -z "$last_name" ]; then
        	last_name="$current_last_name"
    	fi

    	read -p "Date of Birth [$current_dob] (YYYY-MM-DD): " date_of_birth
    	if [ -z "$date_of_birth" ]; then
        	date_of_birth="$current_dob"
    	fi

    	read -p "Email [$current_email]: " email
    	if [ -z "$email" ]; then
        	email="$current_email"
    	fi

    	read -p "Mobile [$current_mobile]: " mobile
    	if [ -z "$mobile" ]; then
        	mobile="$current_mobile"
    	fi

    	read -p "Location ID [$current_location_id]: " location_id
    	if [ -z "$location_id" ]; then
        	location_id="$current_location_id"
    	fi

    	mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "UPDATE employee SET first_name='$first_name', last_name='$last_name', date_of_birth='$date_of_birth', email='$email', mobile='$mobile', location_id='$location_id' WHERE employee_id='$employee_id';"

    	echo "Employee details updated successfully."

	read -n 1 -s -r -p "Press any key to exit..."

}

delete_employee(){
    echo "Deleting an employee"
    read -p "Enter the employee ID to delete: " employee_id
    # Confirm before deletion
    read -p "Are you sure you want to delete employee with ID $employee_id? (y/n): " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "DELETE FROM employee WHERE employee_id='$employee_id';"
        echo "DELETE FROM employee WHERE employee_id='$employee_id';"
        echo "Employee with ID $employee_id has been deleted."
    else
        echo "Deletion cancelled."
    fi

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
	echo "5. Exit"
	echo
	echo
	echo "$message"
}


######################################################
#########   PROGRAM     ##############################
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
			edit_employee;;
		4)
			delete_employee;;
		5)
			echo "exciting"
			break;;
		*) message="Invalid option"
	esac
done









