#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' ]]
  then
    #get team_id
    WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $WTEAM_ID ]]
    then
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    if [[ -z $OTEAM_ID ]]
    then
      INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
  fi
  if [[ $YEAR != 'year' ]]
    then
    WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # echo $OPPONENT
    # echo $OTEAM_ID
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WTEAM_ID, $OTEAM_ID, $WGOALS, $OGOALS)")  
  fi
done