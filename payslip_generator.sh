#!/bin/bash

# Database connection details
DB_NAME="employee_management_system"
DB_USER="ben2"
DB_PASSWORD="ben123456"

# Function to generate payroll and payslip
generate_payroll() {
    echo "Enter Employee ID:"
    read emp_id

    # Get employee details from the database
    employee=$(mysql -u"$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "
        SELECT e.first_name, e.last_name, e.email, p.salary
        FROM employee e
        JOIN position p ON e.employee_id = p.employee_id
        WHERE e.employee_id = $emp_id;" -B --silent)

    if [ -z "$employee" ]; then
        echo "Employee not found."
        return
    fi

    # Extract employee name, email, and salary from the SQL result
    emp_name=$(echo "$employee" | awk '{print $1, $2}')
    emp_email=$(echo "$employee" | awk '{print $3}')
    salary=$(echo "$employee" | awk '{print $4}')

    # Count the number of attendance records for the employee
    attendance_count=$(mysql -u"$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "
        SELECT COUNT(*)
        FROM attendance
        WHERE employee_id = $emp_id;" -B --silent)

    # Calculate gross salary based on actual salary and attendance
    # Assuming salary is a monthly salary, calculate daily rate
    daily_rate=$((salary / 30))
    gross_salary=$((attendance_count * daily_rate))

    # Calculate deductions (10% tax)
    deductions=$((gross_salary / 10))

    # Calculate net salary
    net_salary=$((gross_salary - deductions))

    # Generate the payslip
    payslip_file="payslip_$emp_id.txt"
    {
        echo "----------------------------------------"
        echo "           Employee Payslip             "
        echo "----------------------------------------"
        echo "Employee ID      : $emp_id"
        echo "Employee Name    : $emp_name"
        echo "Days Worked      : $attendance_count"
        echo "----------------------------------------"
        echo "Gross Salary     : \$${gross_salary}"
        echo "Deductions (10%) : \$${deductions}"
        echo "----------------------------------------"
        echo "Net Salary       : \$${net_salary}"
        echo "----------------------------------------"
        echo "Generated on     : $(date '+%Y-%m-%d')"
    } > "$payslip_file"

    cat "$payslip_file"

    echo "                                                       "
    echo "-------------------------------------------------------"
    echo "Payroll generated and payslip saved to $payslip_file."

    # will send to email, Wojciech un comment this if we will be sending to email
#    echo "Would you like to email the payslip to the employee? (y/n)"
 #   read send_email_choice
 #   if [ "$send_email_choice" = "y" ]; then
 #       # Ensure 'mail' is configured on the system
 #       cat "$payslip_file" | mail -s "Payslip for $emp_name" "$emp_email"
 #       echo "Payslip sent to $emp_email."
 #   fi
}

# Run the function
generate_payroll
