#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
QUERY="SELECT (SUM(winner_goals + opponent_goals)) AS total_goals
FROM games;";
echo "$($PSQL "$QUERY")"

echo -e "\nAverage number of goals in all games from the winning teams:"
QUERY="SELECT AVG(winner_goals) AS average_winning_goals
FROM games;";
echo "$($PSQL "$QUERY")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
QUERY="SELECT ROUND(AVG(winner_goals), 2) AS average_winning_goals
FROM games;";
echo "$($PSQL "$QUERY")"

echo -e "\nAverage number of goals in all games from both teams:"
QUERY="SELECT AVG(winner_goals + opponent_goals) AS average_total_goals
FROM games;";
echo "$($PSQL "$QUERY")"

echo -e "\nMost goals scored in a single game by one team:"
QUERY="SELECT MAX(winner_goals) AS max_goals
FROM games;";
echo "$($PSQL "$QUERY")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
QUERY="SELECT COUNT(*) AS count_winner_goals_gt_2
FROM games
WHERE winner_goals > 2;";
echo "$($PSQL "$QUERY")"

echo -e "\nWinner of the 2018 tournament team name:"
QUERY="SELECT name AS winner
FROM teams
    INNER JOIN games ON teams.team_id = games.winner_id
WHERE year = 2018
    AND round = 'Final';";
echo "$($PSQL "$QUERY")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
QUERY="WITH ef2014 AS (
    SELECT winner_id,
        opponent_id
    FROM games
    WHERE year = 2014
        AND round = 'Eighth-Final'
)
SELECT name
FROM teams
    INNER JOIN (
        SELECT winner_id AS team_id
        FROM ef2014
        UNION ALL
        (
            SELECT opponent_id AS team_id
            FROM ef2014
        )
    ) AS result ON result.team_id = teams.team_id
ORDER BY name;";
echo "$($PSQL "$QUERY")"

echo -e "\nList of unique winning team names in the whole data set:"
QUERY="SELECT DISTINCT name
FROM teams
    INNER JOIN games ON teams.team_id = games.winner_id
ORDER BY name;";
echo "$($PSQL "$QUERY")"

echo -e "\nYear and team name of all the champions:"
QUERY="WITH champions AS (
    SELECT year,
        winner_id AS team_id
    FROM games
    WHERE round = 'Final'
)
SELECT year, name
FROM teams
    INNER JOIN champions ON teams.team_id = champions.team_id
ORDER BY year;";
echo "$($PSQL "$QUERY")"

echo -e "\nList of teams that start with 'Co':"
QUERY="SELECT name
FROM teams
WHERE name LIKE 'Co%'
ORDER BY name;";
echo "$($PSQL "$QUERY")"
