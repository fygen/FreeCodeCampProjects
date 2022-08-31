#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ ! -z $1 ]]
then
  if [[ $1 =~ [0-9]+ ]]
  then
    RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1 ")
  else
    RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
  fi
  if [[ -z $RESULT ]]
  then
    echo I could not find that element in the database.
  else
    echo $RESULT | while IFS="|" read TYPE_ID ATOM_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
    do
      SYMBOL=$(echo $SYMBOL | sed -r "s/ //g")
      echo -e "The element with atomic number $ATOM_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius." | sed -r 's/  / /g'
    done
  fi
else
  echo "Please provide an element as an argument."
fi