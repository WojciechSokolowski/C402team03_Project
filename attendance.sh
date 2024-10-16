
# Get Employee details
read -p "Enter Employee ID: " employee_id
read -p "Enter First Name: " first_name
read -p "Enter Last Name: " last_name
read -p "Enter Email: " email

DB_HOST="16.171.135.52"
DB_USER="team03"
DB_PASS="test"
DB_NAME="employee_management_system"

# Check if employee exists in the database
employee_exists=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -se "SELECT COUNT(*) FROM employee WHERE employee_id=$employee_id AND first_name='$first_name' AND last_name='$last_name' AND email='$email';")

if [[ "$employee_exists" -eq 1 ]]; then
# Check if the employee has already checked in but not checked out
	checkin_exists=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -se "SELECT COUNT(*) FROM attendance WHERE employee_id=$employee_id AND checkout_time IS NULL;")
         
        if [[ "$checkin_exists" -eq 0 ]]; then
        # Employee hasn't checked in yet, record check-in time
        	checkin_date=$(date +"%Y-%m-%d")
		checkin_time=$(date +"%H:%M:%S")
        	place=""

		read -p "Please enter place (o - office, ho - home office, cu - customer site): " place
	        	
		mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -se "INSERT INTO attendance (employee_id, checkin_date, checkin_time, place) VALUES ($employee_id, '$checkin_date', '$checkin_time', '$place');"
	        echo "Check-in time recorded: $checkin_time $checkin_time at $place "
        else
                # Employee has checked in but not checked out, so record check-out time
		checkout_time=$(date +"%H:%M:%S")
		checkout_date=$(date +"%Y-%m-%d")
               	mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -se "UPDATE attendance SET checkout_time='$checkout_time' WHERE employee_id=$employee_id AND checkout_time IS NULL;"
                                                                                 
                # Calculate total hours worked
		hours_worked=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -se "SELECT TIMESTAMPDIFF(HOUR, CONCAT(checkin_date, ' ', checkin_time), CONCAT('$checkout_date', ' ', '$checkout_time')) FROM attendance WHERE employee_id=$employee_id AND checkout_time='$checkout_time';")

		echo "Check-out time recorded: $checkout_time"
                echo "Total hours worked: $hours_worked hours"

		if (( hours_worked < 8 )); then
	                read -p "Hours less than 8. Did you get permission from the team leader? (yes/no): " permission
                        if [ "$permission" == "yes" ]; then
	                       	echo "Hours approved by team leader."
                        else
	                       	echo "You need to get approval from the team leader."
			fi
		fi
	fi
else
	echo "Employee not found. Please try again."

fi



