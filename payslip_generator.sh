#!/bin/bash


# Function to generate payroll and payslip
generate_payroll() {
    read -p "Enter Employee ID: " emp_id

    # Validate that emp_id is a number
    if ! [[ "$emp_id" =~ ^[0-9]+$ ]]; then
        echo "Invalid Employee ID. Please enter a numeric value."
        return
    fi

    # Get employee details from the database
    employee=$(mysql -D "$DB_NAME" -e "
        SELECT e.first_name, e.last_name, e.email, p.salary
        FROM employee e
        JOIN position p ON e.employee_id = p.employee_id
        WHERE e.employee_id = $emp_id;" -B --silent)

    if [ -z "$employee" ]; then
        echo "Employee not found."
        return
    fi

    # Extract employee name, email, and salary from the SQL result
    IFS=$'\t' read -r first_name last_name emp_email salary <<< "$employee"
    emp_name="$first_name $last_name"

    # Count the number of attendance records for the employee
    attendance_count=$(mysql -D "$DB_NAME" -e "
        SELECT COUNT(*)
        FROM attendance
        WHERE employee_id = $emp_id;" -B --silent)

    # Calculate gross salary based on actual salary and attendance
    # Assuming salary is a monthly salary, calculate daily rate
    daily_rate=$(echo "scale=2; $salary / 30" | bc)
    gross_salary=$(echo "scale=2; $attendance_count * $daily_rate" | bc)

    # Calculate deductions based on tiered tax rates
    if (( $(echo "$gross_salary <= 2000" | bc -l) )); then
        # Apply 10% tax if gross salary is up to $2,000
        tax_rate=0.10
    else
        # Apply 20% tax if gross salary is above $2,000
        tax_rate=0.20
    fi
    deductions=$(echo "scale=2; $gross_salary * $tax_rate" | bc)

    # Calculate net salary
    net_salary=$(echo "scale=2; $gross_salary - $deductions" | bc)

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
        echo "Tax Rate         : $(echo "$tax_rate * 100" | bc)%"
        echo "Deductions       : \$${deductions}"
        echo "----------------------------------------"
        echo "Net Salary       : \$${net_salary}"
        echo "----------------------------------------"
        echo "Generated on     : $(date '+%Y-%m-%d')"
    } > "$payslip_file"

    # Display the payslip contents to the user
    cat "$payslip_file"

    echo "                                                       "
    echo "-------------------------------------------------------"
    echo "Payroll generated and payslip saved to $payslip_file."

    echo "Would you like to email the payslip to the employee? (y/n)"
    read send_email_choice
    if [ "$send_email_choice" = "y" ]; then
         # Ensure 'mail' is configured on the system
	 subject="Payslip for $emp_name"
	 body=$(cat "$payslip_file")
         echo -e "Subject: $subject\n\n$body" | ssmtp "$emp_email"
	 echo "Payslip sent to $emp_email."
    fi
}

# Run the function
generate_payroll
read -n 1 -s -r -p "Press any key to exit..."

