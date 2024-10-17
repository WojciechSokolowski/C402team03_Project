#!/bin/bash


# Set current date and time
today=$(date +"%Y-%m-%d")

# Check for employees who have not registered attendance by 15:00 on the previous workday
employees=$(mysql -D $DB_NAME -se "
SELECT e.email, e.first_name, e.last_name 
FROM employee e 
LEFT JOIN attendance a 
ON e.employee_id = a.employee_id 
WHERE a.checkin_date = '$today' AND (a.checkin_time IS NULL OR a.checkin_time > '15:00');")

# Loop through employees and send alert emails
echo "$employees" | while read -r employee; do
	email=$(echo $employee | awk '{print $1}')
	first_name=$(echo $employee | awk '{print $2}')
        last_name=$(echo $employee | awk '{print $3}')
        
# Compose the email
	subject="Attendance Alert: Missing check-in for $first_name $last_name"
        body="Dear $first_name $last_name, \n\nOur records indicate that you have not registered your attendance by 15:00 today. Please ensure you check in on time. If this was a mistake, kindly contact your team leader.\n\nBest regards,\nAttendance Team"
                
# Send the email
	echo -e "Subject: $subject\n\n$body" | ssmtp "$email"
        echo "Sent email to $first_name $last_name at $email."
done


#crontab -e
#00 15 * * * /home/ec2-user/team3project



















































