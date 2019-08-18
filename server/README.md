# README

This is the server side specific README. It's really just a collection of reminders for myself on why I did things certain ways and notes while I learn Rails.

## Ruby version

Currently using Ruby 2.4.3

## Database creation

Database is reliant on an existing AWS RDS DB

## Database initialization

In the test ENV, need to make sure the schema is up to date. In order to do that, I relied on the structure.rb sql file. To generate, run:

Get a copy of the most up to date DB Scema
```
$: rails db:structure:dump
```

Switch to the test ENV ahead of changes
```
$: bin/rails db:environment:set RAILS_ENV=test
```

Need to drop the old test DB
```
$: rails db:drop test
```

Create a test DB (but don't migrate yet, the migrations were created after the DB existed already)
```
$: rails db:create RAILS_ENV=test
```

Load the Database Structure
```
$: rails db:structure:load test
```

If this is run multiple times, you'll get conflict issues.

### The previous section _should_ be obsolete now that the migrations have been squashed!

## How to run the test suite

Utilize Guard in the CLI and binding.pry in the test to make your life way easier!
Run all tests with rspec.

## Services (job queues, cache servers, search engines, etc.)

N/A

## Deploying:

Need to serve only the API to the Heroku app hosting service, this is done with the following pattern
```
$: git subtree split --prefix server -b deploy
$: git push -f heroku deploy:master
$: git branch -D deploy
```
