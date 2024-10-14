#!/bin/bash

# Function to view employee details
view_employee() {
    echo "Enter Employee ID:"
    read emp_id

    # Search the CSV file for the employee
    employee=$(grep "^$emp_id," employees.csv)

    if [ -z "$employee" ]; then
        echo "Employee not found."
    else
        # Display employee details
        echo "Employee Details:"
        echo "ID, Name, Department, Role, Email"
        echo "$employee"
    fi
}

view_employee
