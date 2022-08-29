#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
# Database should EXIST--> like named = salon

CLEAN=$($PSQL "DROP TABLE customers,services,appointments  ")
echo $CLEAN

TABLE_CREATION=( 
"CREATE TABLE customers(customer_id SERIAL PRIMARY KEY, phone VARCHAR(25) UNIQUE, name VARCHAR(50))"
"CREATE TABLE services(service_id SERIAL PRIMARY KEY, name VARCHAR(50) )"
"CREATE TABLE appointments(appointment_id SERIAL PRIMARY KEY,time VARCHAR(50) NOT NULL, service_id INT NOT NULL, customer_id INT NOT NULL) "
"ALTER TABLE appointments ADD FOREIGN KEY (service_id) REFERENCES services(service_id)"
"ALTER TABLE appointments ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id)" )

for i in {0..5}
do
  RETURN=$($PSQL "${TABLE_CREATION[i]}")
  echo $RETURN 
done

TABLE_INSERTION=(
"INSERT INTO services(name) VALUES('cut'),('color'),('perm'),('style'),('trim')"
)

RETURN=$($PSQL"${TABLE_INSERTION[0]}")
echo $RETURN. 
echo -e "\nClick enter key to continue"
read KEY
clear