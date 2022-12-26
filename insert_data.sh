#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# constants
# INSERT_SUCCESS="INSERT 0 1";

# subroutines
query_team(){
  SELECT="SELECT team_id
  FROM teams
  WHERE name='$1'";
  echo $($PSQL "$SELECT");
}

insert_team(){
  INSERT="INSERT INTO teams (name)
  VALUES ('$1');";
  echo $($PSQL "$INSERT");
}

# read in the csv file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$(query_team "$WINNER");
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAM_RESULT=$(insert_team "$WINNER");
      WINNER_ID=$(query_team "$WINNER");
    fi
    OPPONENT_ID=$(query_team "$OPPONENT");
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM_RESULT=$(insert_team "$OPPONENT");
      OPPONENT_ID=$(query_team "$OPPONENT");
    fi
    INSERT="INSERT INTO games(
        year,
        round,
        winner_id,
        opponent_id,
        winner_goals,
        opponent_goals
      )
    VALUES (
        $YEAR,
        '$ROUND',
        $WINNER_ID,
        $OPPONENT_ID,
        $WINNER_GOALS,
        $OPPONENT_GOALS
      );";
    INSERT_GAME_RESULT=$($PSQL "$INSERT");
  fi
done