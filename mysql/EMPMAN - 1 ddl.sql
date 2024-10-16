CREATE database employee_management_system;

USE employee_management_system;

CREATE TABLE location
(
	location_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	city_name VARCHAR(30) NOT NULL,
	zip_code VARCHAR(15) NOT NULL,
	country VARCHAR(30) NOT NULL,
	address VARCHAR(50) NOT NULL
);

CREATE TABLE employee
(
	employee_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	date_of_birth DATE NOT NULL,
	email VARCHAR(50) NOT NULL,
	mobile VARCHAR(15) NULL,
	location_id INT UNSIGNED NOT NULL
);

CREATE TABLE attendance
(
	employee_id INT UNSIGNED NOT NULL,
	checkin_date date NOT NULL,
	checkin_time time NOT NULL,
	checkout_time time NOT NULL,
	place ENUM('o', 'ho', 'cu') NOT NULL DEFAULT 'o' COMMENT 'o - office, ho - home office, cu - customer'
);

CREATE TABLE department
(
	department_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	location_id INT UNSIGNED NOT NULL
);

CREATE TABLE position
(
	employee_id INT UNSIGNED NOT NULL,
	department_id INT UNSIGNED NOT NULL,
	name VARCHAR(50) NOT NULL,
	begin_date DATE NOT NULL,
	end_date DATE NOT NULL,
	salary INT NOT NULL,
	ho_per_week SMALLINT NOT NULL
);

ALTER TABLE employee
	ADD FOREIGN KEY (location_id) REFERENCES location(location_id);

ALTER TABLE department
	ADD FOREIGN KEY (location_id) REFERENCES location(location_id);

ALTER TABLE position
    ADD FOREIGN KEY (employee_id) REFERENCES employee(employee_id);
   
ALTER TABLE position
    ADD FOREIGN KEY (department_id) REFERENCES department(department_id);
   
ALTER TABLE attendance
	ADD FOREIGN KEY (employee_id) REFERENCES employee(employee_id);

COMMIT;
