#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

# Home menu
MAIN_MENU (){
  # If function called with error message
  echo -e "\n$1"

  # Get available services from database
  SERVICES=$($PSQL "SELECT service_id, name FROM services")

  # Read available services
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    # Display available services
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  # Ask to pick service
  read SERVICE_ID_SELECTED

  # If not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # Return to home with message
    MAIN_MENU "Please input a number"
  else
    # Check service in database
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    
    # If service doesn't exist
    if [[ -z $SERVICE_NAME ]] 
    then
      # Return to home with message
      MAIN_MENU "I could not find that service. What would you like today?"
    else
        # Ask for phone number
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        # Get customer name from database
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        # If customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # Ask for customer name 
          echo -e "\nI don't have a record of that phone number, what's your name?"
          read CUSTOMER_NAME
          
          # Add customer to database
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
        fi

        # Get customer_id from database
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        # Ask for service time
        echo -e "\nWhat time would you like your $(echo $SERVICE_NAME, $CUSTOMER_NAME? | sed -E 's/^ +| +$//g')"
        read APPOINTMENT_TIME

        # Add appointment to database
        APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VAlUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$APPOINTMENT_TIME')")
        
        # If appointment wasn't succesful
        if [[ $APPOINTMENT_RESULT != "INSERT 0 1" ]] 
        then
          # Return to home with message
          MAIN_MENU "Could not schedule appointment, please schedule another service or try again later."
        else
          # Print success message
          echo -e "\nI have put you down for a $(echo $SERVICE_NAME at $APPOINTMENT_TIME, $CUSTOMER_NAME | sed -E 's/^ +| +$//g')."
        fi
          fi
        fi

  
}


MAIN_MENU "Welcome to My Salon, how can I help you?"