#!/bin/bash

# Database connection details
DB_NAME="employee_management_system"
DB_USER="ben2"
DB_PASSWORD="ben123456"

# Function to view employee details
view_employee() {
    echo -e "\033[1;34mEnter Employee ID:\033[0m"  # Blue bold text for prompt
    read emp_id

    # Query to fetch employee details from the database
    query="SELECT e.employee_id, e.first_name, e.last_name, e.date_of_birth, e.email, e.mobile,
                  l.city_name, l.zip_code, l.country, l.address
           FROM employee e
           JOIN location l ON e.location_id = l.location_id
           WHERE e.employee_id = $emp_id;"

    # Execute the query and capture the result
    result=$(mysql -u"$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "$query" -B --silent)

    # Check if the result is empty
    if [ -z "$result" ]; then
        echo -e "\033[1;31mEmployee with ID $emp_id not found.\033[0m"  # Red text for not found
    else
        # Parse the result into variables
        IFS=$'\t' read -r emp_id first_name last_name dob email mobile city_name zip_code country address <<< "$result"

        # Display fancy employee details
        echo -e "\033[1;32m╔═════════════════════════════════════════════╗\033[0m"  # Green border
        echo -e "\033[1;32m║              \033[1;33mEmployee Details\033[1;32m               ║\033[0m"  # Yellow title
        echo -e "\033[1;32m╠═════════════════════════════════════════════╣\033[0m"
        echo -e "\033[1;32m║\033[0m ID        : \033[1;36m$emp_id\033[0m"      # Cyan for values
        echo -e "\033[1;32m║\033[0m Name      : \033[1;36m$first_name $last_name\033[0m"
        echo -e "\033[1;32m║\033[0m DOB       : \033[1;36m$dob\033[0m"
        echo -e "\033[1;32m║\033[0m Email     : \033[1;36m$email\033[0m"
        echo -e "\033[1;32m║\033[0m Mobile    : \033[1;36m$mobile\033[0m"
        echo -e "\033[1;32m║\033[0m City      : \033[1;36m$city_name\033[0m"
        echo -e "\033[1;32m║\033[0m Zip Code  : \033[1;36m$zip_code\033[0m"
        echo -e "\033[1;32m║\033[0m Country   : \033[1;36m$country\033[0m"
        echo -e "\033[1;32m║\033[0m Address   : \033[1;36m$address\033[0m"
        echo -e "\033[1;32m╚═════════════════════════════════════════════╝\033[0m"
    fi
}

# Run the function
view_employee
