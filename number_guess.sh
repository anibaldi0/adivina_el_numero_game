#!/bin/bash

#conectar a la db
PSQL="psql --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"

echo "Enter your username:"
read USER_NAME

USER_NAME_AVAILABLE=$($PSQL "SELECT user_name FROM users WHERE user_name = '$USER_NAME'")
GAMES_PLAYED=$($PSQL "SELECT COUNT (*) FROM users INNER JOIN games USING (user_id) WHERE user_name = '$USER_NAME'")
BEST_GAME=$($PSQL "SELECT MIN (number_guesses) FROM users INNER JOIN games USING (user_id) WHERE user_name = '$USER_NAME'")

if [[ -z $USER_NAME_AVAILABLE ]]
  then
    INSERT_USER=$($PSQL "INSERT INTO users (user_name) VALUES ('$USER_NAME')")
    echo "Welcome, $USER_NAME! It looks like this is your first time here."
  else
    echo "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RANDOM_NUM=$(( 1 + $RANDOM % 1000 ))
GUESS=1
echo "Guess the secret number between 1 and 1000:"

while read NUM
do
  if [[ ! $NUM =~ ^[0-9]+$ ]] #para confirmar que lo que se ingresa sea un numero
    then
      echo "That is not an integer, guess again:"
    else
      if [[ $NUM -eq $RANDOM_NUM ]]
        then
          break;
        else
          if [[ $NUM -gt $RANDOM_NUM ]]
            then
              echo -n "It's lower than that, guess again: "
              elif [[ $NUM -lt $RANDOM_NUM ]]
                then
                  echo -n "It's higher than that, guess again: "
          fi
      fi         
  fi
  GUESS=$(( $GUESS + 1 ))
done

if [[ $GUESS == 1 ]]
  then 
    echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"
  else
    echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"

fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USER_NAME'")
INSERT_GAME=$($PSQL "INSERT INTO games (number_guesses, user_id) VALUES ($GUESS, $USER_ID)")
