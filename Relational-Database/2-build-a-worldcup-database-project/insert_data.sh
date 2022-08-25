#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
RESULT_TRUNCATE=$($PSQL "TRUNCATE TABLE games, teams")
echo $RESULT_TRUNCATE success.

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    GET_OPP_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $GET_OPP_NAME ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')" )
      if [[ $INSERT_OPPONENT == 'INSERT 0 1' ]]
      then 
        echo -e "\nOPPONENT: $OPPONENT inserted into teams."
      fi
    fi
    GET_WIN_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $GET_WIN_NAME ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo -e "\nWINNER: $WINNER inserted into teams."
      fi
    fi
    
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    RESULT_INSERT=$($PSQL "INSERT INTO games(year,winner_id,opponent_id,winner_goals,opponent_goals,round) VALUES($YEAR,$WIN_ID,$OPP_ID,$WINNER_GOALS,$OPPONENT_GOALS,'$ROUND')")
    if [[ $RESULT_INSERT == 'INSERT 0 1' ]]
    then
      echo -e "\nINSERTED GAME: $YEAR,$WIN_ID,$OPP_ID,$WINNER_GOALS,$OPPONENT_GOALS,'$ROUND'"
    fi
  fi
done