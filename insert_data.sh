#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# remove every details 
echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")
# read file from games.csv 
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# ignore first line of games.csv file 
  if [[ $YEAR != 'year' ]] 
# check in Teams for Winner 
    then
      INSERT_WINNER=$($PSQL "SELECT team_id FROM teams where name='$WINNER'") 
      if [[ -z $INSERT_WINNER  ]] 
      then 
        #INSERT in WINNER
        echo $($PSQL "INSERT INTO teams(name) values('$WINNER')" ) 
      fi
        #check in teams for opponent
          INSERT_OPPONENT=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'") 
      if [[ -z $INSERT_OPPONENT ]] 
      then
        #Insert in opponent into teamas
        echo $($PSQL "INSERT INTO teams(name) values('$OPPONENT')" ) 
      fi
      #Check in winner_id 
      INSERT_WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'") 
      INSERT_OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'") 
      #Insert the rest of data into games excluding the "id" 
      echo $($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $INSERT_WINNER_ID, $INSERT_OPPONENT_ID)")
      #Insert in team_id into winner_id and into opponent_id 
      #echo $($PSQL "INSERT INTO games(winner_id) values($INSERT_WINNER_ID)")



      


  fi
done
