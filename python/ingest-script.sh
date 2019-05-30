#! /bin/bash
week=$1

echo '--- Ingesting Football Outsiders Data ---'
python3 ./football-outsiders/foScrape.py "$week"
echo '--- DONE ---'

echo '--- Ingesting Team Rankings Data ---'
python3 ./team-rankings/trScrape.py "$week"
echo '--- DONE ---'

echo '--- Ingesting ESPN Data ---'
python3 ./espn/espnScrape.py "$week"

echo '--- Complete ---'