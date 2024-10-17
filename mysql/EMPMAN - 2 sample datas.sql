USE employee_management_system;


INSERT INTO location (city_name, zip_code, country, address)
WITH rows_to_insert AS (
	SELECT 'Port Carolmouth' AS c_n, 57314 AS z_c, 'UK' AS co, 'Spruce Lane 543' AS addr
	UNION SELECT 'South Maryberg', 7488, 'UK', 'Hickory street 876'
	UNION SELECT 'Berlinner', 68359, 'Germany', 'Maple Street 123'
	UNION SELECT 'Robertmouth', 43305, 'Germany', 'Oak way 456'
	UNION SELECT 'Robertmouth', 43305, 'Germany', 'Oak way 450'
	UNION SELECT 'Berlinner', 67315, 'Germany', 'Hoelkce strasse 43.'
	UNION SELECT 'Rockfort', 44431, 'UK', 'Jimi Hendrix avenue 42.'
						)
SELECT 	c_n, z_c, co, addr FROM rows_to_insert rti
WHERE 	NOT EXISTS (SELECT * FROM location l WHERE rti.c_n = l.city_name AND rti.z_c = l.zip_code 
													AND rti.co = l.country AND rti.addr = l.address);

INSERT INTO employee (first_name, last_name, date_of_birth, email, mobile, location_id)
WITH rows_to_insert AS (
		SELECT 'Jenna' AS fn, 'Sanchez' AS l_n , '1997-08-27' AS dob, 'jennasanchez31@frozenretail.com' AS em, '66613581' AS mob, 1 AS locid
		UNION SELECT 'Rachael', 'Banks', '1972-12-07', 'rachaelbanks415@frozenretail.com', '2222233322', 2
		UNION SELECT 'Melissa', 'Cox', '1983-09-10', 'melissacox283@company.com', '113542135', 1
		UNION SELECT 'Rachael', 'Banks', '1972-12-07', 'rachaelbanks415@frozenretail.com', '2222233322', 2
		UNION SELECT 'Joseph', 'Braun', '1991-02-10', 'josephbraun1237@frozenretail.com', '333444863', 1
		UNION SELECT 'Joshua', 'Garrison', '1989-03-21', 'joshuagarrison1279@frozenretail.com', '4444355744', 4
		UNION SELECT 'Mandy', 'Chandler', '1986-09-22', 'mandychandler1338@frozenretail.com', '555632168', 5		
					)
SELECT	fn, l_n, dob, em, mob, locid FROM rows_to_insert rti
WHERE 	NOT EXISTS (SELECT * FROM employee e WHERE rti.fn = e.first_name AND rti.l_n = e.last_name AND rti.dob = e.date_of_birth
													AND rti.em = e.email AND rti.mob = e.mobile AND rti.locid = e.location_id); 

INSERT INTO department (name, location_id)
WITH rows_to_insert AS (
		SELECT	'Research and development' n, 7 locid
		UNION SELECT 'Public relations', 6
		UNION SELECT 'Engineering', 6
					)
SELECT 	n, locid FROM rows_to_insert rti
WHERE 	NOT EXISTS (SELECT * FROM department d WHERE rti.n = d.name AND rti.locid = d.location_id);


INSERT INTO position (employee_id, department_id, name, begin_date, end_date, salary, ho_per_week)
WITH rows_to_insert AS (
		SELECT 1 AS e_id, 1 AS d_id, 'Software Engineer' AS name, '2022-01-15' AS b_d, '2023-12-31' AS e_d, 7500 AS s, 3 AS ho
		UNION SELECT 2, 1, 'Systems Administrator', '2021-06-01', '2024-06-01', 6800, 1
		UNION SELECT 3, 1, 'DevOps Engineer', '2020-09-01', '2024-09-01', 8000, 3
		UNION SELECT 4, 1, 'Marketing Manager', '2019-05-15', '2024-05-15', 8500, 2
		UNION SELECT 5, 2, 'Digital Marketing Specialist', '2023-02-10', '2024-12-31', 6200, 2
		UNION SELECT 6, 3, 'SEO Analyst', '2021-11-25', '2024-11-25', 6700, 2
						)
SELECT 	e_id, d_id, name, b_d, e_d, s, ho FROM rows_to_insert rti
WHERE	NOT EXISTS (SELECT * FROM position p WHERE rti.e_id = p.employee_id AND rti.d_id = p.department_id AND rti.name = p.name
									AND rti.b_d = p.begin_date AND rti.e_d = p.end_date AND rti.s = p.salary AND rti.ho = p.ho_per_week);
		

INSERT INTO attendance (employee_id, checkin_date, checkin_time, checkout_time, place)
WITH rows_to_insert AS (
		SELECT 1 AS e_id, '2024-10-10' AS d, '09:00:00' AS ci, '17:30:00' AS co, 'o' AS pl
		UNION SELECT 1, '2024-10-11', '09:00:00', '17:30:00', 'ho'
		UNION SELECT 1, '2024-10-12', '09:00:00', '17:30:00', 'cu'
		UNION SELECT 1, '2024-10-13', '09:00:00', '17:30:00', 'o'
		UNION SELECT 1, '2024-10-14', '09:00:00', '17:30:00', 'ho'
		UNION SELECT 2, '2024-10-10', '08:30:00', '17:00:00', 'ho'
		UNION SELECT 2, '2024-10-11', '08:30:00', '17:00:00', 'cu'
		UNION SELECT 2, '2024-10-12', '08:30:00', '17:00:00', 'o'
		UNION SELECT 2, '2024-10-13', '08:30:00', '17:00:00', 'ho'
		UNION SELECT 2, '2024-10-14', '08:30:00', '17:00:00', 'cu'
		UNION SELECT 3, '2024-10-10', '09:30:00', '18:00:00', 'cu'
		UNION SELECT 3, '2024-10-11', '09:30:00', '18:00:00', 'ho'
		UNION SELECT 3, '2024-10-12', '09:30:00', '18:00:00', 'o'
		UNION SELECT 3, '2024-10-13', '09:30:00', '18:00:00', 'cu'
		UNION SELECT 3, '2024-10-14', '09:30:00', '18:00:00', 'ho'
		UNION SELECT 4, '2024-10-10', '08:45:00', '17:15:00', 'o'
		UNION SELECT 4, '2024-10-11', '08:45:00', '17:15:00', 'ho'
		UNION SELECT 4, '2024-10-12', '08:45:00', '17:15:00', 'cu'
		UNION SELECT 4, '2024-10-13', '08:45:00', '17:15:00', 'o'
		UNION SELECT 4, '2024-10-14', '08:45:00', '17:15:00', 'ho'
		UNION SELECT 5, '2024-10-10', '10:00:00', '18:30:00', 'ho'
		UNION SELECT 5, '2024-10-11', '10:00:00', '18:30:00', 'cu'
		UNION SELECT 5, '2024-10-12', '10:00:00', '18:30:00', 'o'
		UNION SELECT 5, '2024-10-13', '10:00:00', '18:30:00', 'ho'
		UNION SELECT 5, '2024-10-14', '10:00:00', '18:30:00', 'cu'
		UNION SELECT 6, '2024-10-10', '07:45:00', '16:15:00', 'cu'
		UNION SELECT 6, '2024-10-11', '07:45:00', '16:15:00', 'o'
		UNION SELECT 6, '2024-10-12', '07:45:00', '16:15:00', 'ho'
		UNION SELECT 6, '2024-10-13', '07:45:00', '16:15:00', 'cu'
		UNION SELECT 6, '2024-10-14', '07:45:00', '16:15:00', 'o'
						)
SELECT e_id, d, ci, co, pl FROM rows_to_insert rti
WHERE	NOT EXISTS (SELECT * FROM attendance a WHERE rti.e_id = a.employee_id AND rti.d = a.checkin_date AND rti.ci = a.checkin_time
												AND rti.co = a.checkout_time AND rti.pl = a.place);
											
COMMIT;
