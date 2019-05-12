# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

In the test ENV, need to make sure the schema is up to date. In order to do that, I relied on the structure.rb sql file. To generate, run:

```
$: rails db:structure:dump
```

```
$: rails db:structure:load test
```

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
