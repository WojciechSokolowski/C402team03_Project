#!/bin/bash
#

message=""

display_employees(){
	echo "Employee list"
        mysql -D "$DB_NAME" -e "
        SELECT 
            e.employee_id AS 'ID', 
            CONCAT(e.first_name, ' ', e.last_name) AS 'Name',
	    IFNULL(ROUND(AVG(er.overall_score),1), 'N/A') AS 'Average Score'
        FROM 
            employee e
        LEFT JOIN 
            emp_review er ON e.employee_id = er.employee_id
        GROUP BY 
            e.employee_id;
    " | column -t -s $'\t'
    	echo ""
    	read -n 1 -s -r -p "Press any key to continue..."

}
add_employee(){
	echo "Creating new employee"
	read -p "Would you like to enter the data in one line? (yes/no): " response
	
	if [[ "$response" == "yes" || "$response" == "y" || "$response" == "Y" ]]; then
        
         	read -p "Enter employee details (first_name last_name date_of_birth email mobile location_id department_id position_name begin_date end_date salary hours_per_week): " employee_data
       		IFS=' ' read -r first_name last_name date_of_birth email mobile location_id department_id position_name begin_date end_date salary hours_per_week <<< "$employee_data"

        	echo "You entered the following details:"
        	echo "First Name: $first_name"
        	echo "Last Name: $last_name"
	        echo "Date of Birth: $date_of_birth"
	        echo "Email: $email"
	        echo "Mobile: $mobile"
	        echo "Location ID: $location_id"
	        echo "Department ID: $department_id"
	        echo "Position Name: $position_name"
	        echo "Beginning Date: $begin_date"
	        echo "Ending Date: $end_date"
	        echo "Salary: $salary"
	        echo "Hours per Week: $hours_per_week"


		read -p "Is everything correct? (yes/no): " confirmation
        
        	if [[ "$confirmation" == "yes" || "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
             		mysql -D "$DB_NAME" -e "INSERT INTO employee (first_name, last_name, date_of_birth, email, mobile, location_id) VALUES ('$first_name', '$last_name', '$date_of_birth', '$email', '$mobile', '$location_id');"
  			employee_id=$(mysql -D "$DB_NAME" -se "SELECT MAX(employee_id) FROM employee;")
				
            		mysql -D "$DB_NAME" -e "
            		INSERT INTO position (employee_id, department_id, name, begin_date, end_date, salary, ho_per_week)
            		VALUES ($employee_id, $department_id, '$position_name', '$begin_date', '$end_date', $salary, $hours_per_week);
            		"
            		echo "Employee added successfully."
        	else
            		echo "Employee addition cancelled."
        	fi
	
	else
	
	
		read -p "Enter first name: " first_name
    		read -p "Enter last name: " last_name
    		read -p "Enter date of birth (YYYY-MM-DD): " date_of_birth
    		read -p "Enter email: " email
   		read -p "Enter mobile number: " mobile
    		read -p "Enter location ID: " location_id

		read -p "Enter department ID: " department_id
		read -p "Enter position name (max 50 characters): " name
		read -p "Enter begining date (YYYY-MM-DD): " begin_date
		read -p "Enter ending date (YYYY-MM-DD): " end_date
		read -p "Enter salary: " salary
		read -p "Enter hours per week: " ho_per_week
		mysql -D "$DB_NAME" -e "INSERT INTO employee (first_name, last_name, date_of_birth, email, mobile, location_id) VALUES ('$first_name', '$last_name', '$date_of_birth', '$email', '$mobile', '$location_id');"

		employee_id=$(mysql -D "$DB_NAME" -se "SELECT MAX(employee_id) FROM employee;")
		
		mysql -D "$DB_NAME" -e "INSERT INTO position (employee_id, department_id, name, begin_date, end_date, salary, ho_per_week)
        VALUES ($employee_id, $department_id, '$name', '$begin_date', '$end_date', $salary, $ho_per_week);
        "

        echo "Employee and position added successfully."


	fi	
	read -n 1 -s -r -p "Press any key to exit..."
}

edit_employee(){

	read -p "Enter the employee ID to edit: " employee_id

	    employee=$(mysql -D "$DB_NAME" -se "SELECT first_name, last_name, date_of_birth, email, mobile, location_id FROM employee WHERE employee_id='$employee_id';")
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

    	mysql -D "$DB_NAME" -e "UPDATE employee SET first_name='$first_name', last_name='$last_name', date_of_birth='$date_of_birth', email='$email', mobile='$mobile', location_id='$location_id' WHERE employee_id='$employee_id';"

    	echo "Employee details updated successfully."

	read -p "Do you need to edit also position table? (y/n): " second_edit

	if [[ $second_edit == "y" || $second_edit == "Y" || $second_edit == "yes" ]]; then
		
		position=$(mysql -D "$DB_NAME" -se "SELECT department_id, name, begin_date, end_date, salary, ho_per_week FROM position WHERE employee_id='$employee_id';")

    		if [ -z "$position" ]; then
        		echo "No position found for employee ID $employee_id. Please add position details."
    		else
        		IFS=$'\t' read -r current_department_id current_position_name current_begin_date current_end_date current_salary current_ho_per_week <<< "$position"

        		echo "Press enter to NOT edit each data for position"
       			read -p "Department ID [$current_department_id]: " department_id
        		if [ -z "$department_id" ]; then
            			department_id="$current_department_id"
        		fi

        		read -p "Position Name [$current_position_name]: " position_name
        		if [ -z "$position_name" ]; then
            			position_name="$current_position_name"
        		fi

        		read -p "Begin Date [$current_begin_date] (YYYY-MM-DD): " begin_date
        		if [ -z "$begin_date" ]; then
            			begin_date="$current_begin_date"
        		fi

        		read -p "End Date [$current_end_date] (YYYY-MM-DD): " end_date
        		if [ -z "$end_date" ]; then
            			end_date="$current_end_date"
        		fi

        		read -p "Salary [$current_salary]: " salary
        		if [ -z "$salary" ]; then
            			salary="$current_salary"
        		fi

        		read -p "Hours Per Week [$current_ho_per_week]: " hours_per_week
        		if [ -z "$hours_per_week" ]; then
            			hours_per_week="$current_ho_per_week"
        		fi
		fi
	fi

	read -n 1 -s -r -p "Press any key to exit..."

}

delete_employee(){
    echo "Deleting an employee"
    read -p "Enter the employee ID to delete: " employee_id
    # Confirm before deletion
    read -p "Are you sure you want to delete employee with ID $employee_id? (y/n): " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        mysql -D "$DB_NAME" -e "DELETE FROM employee WHERE employee_id='$employee_id';"
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









