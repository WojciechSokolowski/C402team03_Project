
#!/bin/bash

# Get Employee details
read -p "Enter Employee ID: " employee_id
#read -p "Enter First Name: " first_name
#read -p "Enter Last Name: " last_name
#read -p "Enter Email: " email


# Check if employee exists in the MySQL database
#employee_exists=$(mysql -D $DB_NAME -se "SELECT COUNT(*) FROM employee WHERE employee_id=$employee_id AND first_name='$first_name' AND last_name='$last_name' AND email='$email';")
employee_exists=$(mysql -D $DB_NAME -se "SELECT COUNT(*) FROM employee WHERE employee_id=$employee_id;")

if [ "$employee_exists" -eq 1 ]; then
# Get check-in and check-out times
	read -p "Please enter check-in date (YYYY-MM-DD): " checkin_date
        read -p "Please enter check-in time (HH:MM:SS): " checkin_time
        #read -p "Please enter check-out date (YYYY-MM-DD): " checkout_date
        read -p "Please enter check-out time (HH:MM:SS): " checkout_time
        place=""
                            
        read -p "Please enter place (o - office, ho - home office, cu - customer site): " place
                                    
# Insert check-in and check-out information into attendance table
	mysql -D $DB_NAME -e "INSERT INTO attendance (employee_id, checkin_date, checkin_time, checkout_time, place) VALUES ($employee_id, '$checkin_date', '$checkin_time', '$checkout_time', '$place');"
                                                
# Calculate total hours worked
	hours_worked=$(mysql -D $DB_NAME -se "SELECT TIMESTAMPDIFF(HOUR, CONCAT(checkin_date, ' ', checkin_time), CONCAT(checkin_date, ' ', checkout_time)) FROM attendance WHERE employee_id=$employee_id AND checkin_date='$checkin_date';")

        echo "Check-in time recorded: $checkin_date $checkin_time at $place"
        echo "Check-out time recorded: $checkin_date $checkout_time"
        echo "Total hours worked: $hours_worked hours"

# Check if hours worked are less than 8
        if (( hours_worked < 8 )); then
 	       read -p "Hours less than 8. Did you get permission from the team leader? (yes/no): " permission
               if [ "$permission" == "yes" ]; then
	               echo "Hours approved by team leader."
               else
	               echo "You need to get approval from the team leader."
               fi
	fi
else
	echo "Employee not found. Please try again."
fi
read -n 1 -s -r -p "Press any key to exit..."

