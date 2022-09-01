#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -t --no-align -c"

# Looping through reads
READ_LOOP() { #  $1=$Rand $2=$NumbOfGuess  
  # Every time entered the read loop add one to the number_of_guesses
  NUMBER_OF_GUESSES=$(($2+1))
  read GUESS
  GUESS_LOOP $GUESS $1 $NUMBER_OF_GUESSES
}

# if guess lower or higher
GUESS_LOOP() {  # $1=$Guess $2=$Rand $3=$NumbOfGuess
  # if GUESS is a number
  if [[ $1 =~ [0-9]+ ]]
  then
    # if GUESS is lower than RAND
    if [[ $1 -lt $2 ]]
    then
      echo -e "It's higher than that, guess again:"
      # number_of_guesses +1
      READ_LOOP $RAND $NUMBER_OF_GUESSES
    # if GUESS higher than RAND
    elif [[ $1 -gt $2 ]]
    then
      echo -e "It's lower than that, guess again:"
      READ_LOOP $RAND $NUMBER_OF_GUESSES
    # GUESS is equal to RAND
    else 
      # INSERT NUMBER OF GUESSES DB
      GET_BEST=$($PSQL "SELECT best_game FROM users WHERE username='$USER'")
      if [[ $GET_BEST -gt $3 ]]
      then
        INSERT_NOG=$($PSQL "UPDATE users SET best_game=$3 WHERE username='$USER'")
      fi
      END_FN $2 $3

    fi
  # else if guess is not integer try again
  else
    echo "That is not an integer, guess again: "
  fi
}

MAIN_MENU () {
  echo "Enter your username:"
  read USER

  # get USER credentals
  RESULT=$($PSQL "SELECT * FROM users WHERE username='$USER'")

  # if USER in database
  if [[ ! -z $RESULT ]]
  then
    echo $RESULT | while IFS="|" read USERNAME GAMES_PLAYED BEST_GAME USER_ID
    do
      echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
      # every game add one to the Games Played 
      GAMES_PLAYED=$(($GAMES_PLAYED+1))
      UPDATE_GP=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USER'")
    done
  # else Welcome new user
  else
    echo Welcome, $USER! It looks like this is your first time here.
    INSERT_USER=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USER',1,999)")
  fi

  # start guessing section
  RAND=$(($RANDOM%1001))
  echo Rand: $RAND
  echo "Guess the secret number between 1 and 1000:"
  READ_LOOP $RAND 0
}
END_FN(){
      echo -e "\nYou guessed it in $2 tries. The secret number was $1. Nice job!"
}

MAIN_MENU