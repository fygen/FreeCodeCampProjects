#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

VALUES=(
"1,'nonmetal',1.008,-259.1,-252.9,1"
"2,'nonmetal',4.0026,-272.2,-269,1"
"3,'metal',6.94,180.54,1342,2"
"4,'metal',9.0122,1287,2470,2"
"5,'metalloid',10.81,2075,4000,3"
"6,'nonmetal',12.011,3550,4027,1"
"7,'nonmetal',14.007,-210.1,-195.8,1"
"8,'nonmetal',15.999,-218,-183,1"
"1000,'metalloid',1,10,100,3"
)

INSERT(){
  $($PSQL "INSERT INTO properties(atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,type_id) VALUES($1)")
}
for i in ${!VALUES[@]}
do
  echo ${VALUES[i]}
  INSERT ${VALUES[i]}
  # echo ${VALUES[i]} | while IFS="," read ATOMIC_NUMBER TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
  #  do
  #   echo $ATOMIC_MASS
  #   INSERT $ATOMIC_NUMBER $TYPE $ATOMIC_MASS $MELTING_POINT $BOILING_POINT $TYPE_ID
  #  done
done

