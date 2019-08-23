#! bin/bash

clear

# deploy front-end
echo 'Deploying Front End'
git subtree push --prefix client heroku-ui master

# deploy back-end
echo 'Deploying Back End'
git subtree push --prefix client heroku-api master

