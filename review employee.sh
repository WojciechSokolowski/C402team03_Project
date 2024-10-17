#!/bin/bash
#

message=""

display_reviews(){
        echo "Review list"
        mysql  -D "$DB_NAME" -e "SELECT er.reviewer_id AS ID_rev, concat(rev.first_name, " ", rev.last_name) AS Reviewer_name, e.employee_id AS ID_emp, concat(e.first_name, " ", e.last_name) AS Employee_name, er.review_date AS Date_of_review, er.review AS Review, er.overall_score AS Score FROM emp_review er INNER JOIN employee rev ON er.reviewer_id = rev.employee_id INNER JOIN employee e ON er.employee_id = e.employee_id;" | column -t -s $'\t'

        echo ""
        read -n 1 -s -r -p "Press any key to continue..."

}

add_review(){
        echo "Creating new review"
        
        read -p "Enter the Reviewers ID: " reviewer_id
        read -p "Enter the Employee ID:" employee_id
        read -p "Enter date of review (YYYY-MM-DD): " review_date
        read -pr "Enter review text: " review
        read -p "Enter score (greater than 0.0 and less than 10.0): " overall_score

        mysql -D "$DB_NAME" -e "INSERT INTO emp_review (reviewer_id, employee_id, review_date, review, overall_score) VALUES ('$reviewer_id', '$employee_id', '$review_date', '$review', '$overall_score');"

        fi
        read -n 1 -s -r -p "Press any key to exit..."
}

edit_review(){

        read -p "Enter the reviewer ID <space> employee ID <space> review date <space> YYYY-MM-DD to edit: " reviewer_id employee_id review_date

            review=$(mysql -D "$DB_NAME" -se "SELECT reviewer_id, employee_id, review_date, overall_score FROM emp_review er WHERE reviewer_id = '$reviewer_id' AND employee_id = '$employee_id' AND review_date = '$review_date';")

        if [ -z "$review" ]; then
                message="No review found with reviewer ID $reviewer_id, employee ID $employee_id and review date $review_date"
                return
        fi

        IFS=$'\t' read -r cur_reviewer_id cur_employee_id cur_review_date cur_overall_score <<< "$review"

        echo "Press enter to NOT edit each data"
        read -p "Reviewer ID [$cur_reviewer_id]: " reviewer_id
        if [ -z "$reviewer_id" ]; then
                reviewer_id="$cur_reviewer_id"
        fi

        read -p "Employee ID [$cur_employee_id]: " employee_id
        if [ -z "$employee_id" ]; then
                employee_id="$cur_employee_id"
        fi

        read -p "Review date [$cur_review_date] (YYYY-MM-DD): " review_date
        if [ -z "$review_date" ]; then
                review_date="$cur_review_date"
        fi

        read -pr "Review text [$cur_review_t]: " review_t
        if [ -z "$review_t" ]; then
                review_t=$(mysql -D "$DB_NAME" -se "SELECT review FROM emp_review er WHERE reviewer_id = '$reviewer_id' AND employee_id = '$employee_id' AND review_date = '$review_date';")
        fi

        read -p "Overall score [$cur_overall_score]: " overall_score
        if [ -z "$overall_score" ]; then
                overall_score="$cur_overall_score"
        fi

        mysql -D "$DB_NAME" -e "UPDATE emp_review SET review='$review_t', overall_score='$overall_score' WHERE reviewer_id='$reviewer_id' AND employee_id='$employee_id' AND review_date='$review_date';"

        echo "Review details updated successfully."

        read -n 1 -s -r -p "Press any key to exit..."

}

delete_review(){
    echo "Deleting a review"
    read -p "Enter the reviewer ID <space> employee ID <space> review date <space> YYYY-MM-DD to delete: " reviewer_id employee_id review_date
    # Confirm before deletion
    read -p "Are you sure you want to delete review with r_ID $reviewer_id, e_ID $employee_id, date $review_date? (y/n): " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        mysql -D "$DB_NAME" -e "DELETE FROM emp_review WHERE reviewer_id='$reviewer_id' AND employee_id='$employee_id' AND review_date='$review_date';"
        echo " Review with r_ID $reviewer_id, e_ID $employee_id, date $review_date has been deleted."
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

        echo "Editing reviews"
        echo "1. Read all reviews"
        echo "2. Add a new review"
        echo "3. Edit review"
        echo "4. Remove review"
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
                        display_reviews;;
                2)
                        add_review;;
                3)
                        edit_review;;
                4)
                        delete_review;;
                5)
                        echo "exiting"
                        break;;
                *) message="Invalid option"
        esac
done


