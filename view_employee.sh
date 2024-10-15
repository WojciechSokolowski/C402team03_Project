#!/bin/bash

# Function to view employee details
view_employee() {
    echo -e "\033[1;34mEnter Employee ID:\033[0m"  # Blue bold text for prompt
    read emp_id

    # Check if employees.csv exists
    if [ ! -f employees.csv ]; then
        echo -e "\033[1;31mError: employees.csv file not found.\033[0m"  # Red text for error
        return
    fi

    # Search the CSV file for the employee
    employee=$(grep "^$emp_id," employees.csv)

    # Check if the employee was found
    if [ -z "$employee" ]; then
        echo -e "\033[1;31mEmployee with ID $emp_id not found.\033[0m"  # Red text for not found
    else
        # Extract employee details
        emp_id=$(echo $employee | cut -d',' -f1)
        emp_name=$(echo $employee | cut -d',' -f2)
        emp_dept=$(echo $employee | cut -d',' -f3)
        emp_role=$(echo $employee | cut -d',' -f4)
        emp_email=$(echo $employee | cut -d',' -f5)

        # Display employee details
        echo -e "\033[1;32m╔═════════════════════════════════════════════╗\033[0m"  # Green border
        echo -e "\033[1;32m║              \033[1;33mEmployee Details\033[1;32m               ║\033[0m"  # Yellow title
        echo -e "\033[1;32m╠═════════════════════════════════════════════╣\033[0m"
        echo -e "\033[1;32m║\033[0m ID        : \033[1;36m$emp_id\033[0m"      # Cyan for values
        echo -e "\033[1;32m║\033[0m Name      : \033[1;36m$emp_name\033[0m"
        echo -e "\033[1;32m║\033[0m Department: \033[1;36m$emp_dept\033[0m"
        echo -e "\033[1;32m║\033[0m Role      : \033[1;36m$emp_role\033[0m"
        echo -e "\033[1;32m║\033[0m Email     : \033[1;36m$emp_email\033[0m"
        echo -e "\033[1;32m╚═════════════════════════════════════════════╝\033[0m"
    fi
}

view_employee

