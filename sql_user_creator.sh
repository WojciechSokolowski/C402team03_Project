#!/bin/bash
#
create_mysql_user() {
}








while true;do

	read -p "Enter command" user_type

	case $user_type in
		1)
			create_mysql_user "admin"
			;;
		2)
			create_mysql_user "manager"
			;;
		3)
			create_mysql_user "employee"
			;;
		4)
			describe
			;;
		5)
			
