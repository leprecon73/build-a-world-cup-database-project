#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != year ]]
    then
      if [[ $($PSQL "SELECT COUNT(name) FROM teams WHERE name = '$winner'") -eq 0 ]]
        then
          INSERT_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$winner')")

          if [[ $INSERT_TEAM == "INSERT 0 1" ]]
            then
              echo -e "Inserted into teams(name) value '$winner', $INSERT_TEAM"
            fi
        fi
      if [[ $($PSQL "SELECT COUNT(name) FROM teams WHERE name = '$opponent'") -eq 0 ]]
        then
          INSERT_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$opponent')")

          if [[ $INSERT_TEAM == "INSERT 0 1" ]]
            then
              echo -e "Inserted into teams(name) value '$winner', $INSERT_TEAM"
            fi
        fi
    fi
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != year ]]
    then
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
      INSERT_GAME=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$winner_id', '$opponent_id', '$winner_goals', '$opponent_goals')")
      echo -e"\n $INSERT_GAME values $year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals"
    fi

done
