# README

This is the server side specific README. It's really just a collection of reminders for myself on why I did things certain ways and notes while I learn Rails.

* Ruby version

Currently using Ruby 2.4.3

* Database creation

Database is reliant on an existing AWS RDS DB

* Database initialization

In the test ENV, need to make sure the schema is up to date. In order to do that, I relied on the structure.rb sql file. To generate, run:

```
$: rails db:structure:dump
```

```
$: rails db:drop test
```

```
$: rails db:structure:load test
```

If this is run multiple times, you'll get conflict issues.

* How to run the test suite

Utilize Guard in the CLI and binding.pry in the test to make your life way easier!

* Services (job queues, cache servers, search engines, etc.)
