tweetwatch
===========

Tweetwatch allows you to watch a list of Twitter topics in real time
And Display the N number of most retweeted tweets in the last N minutes.

Installation
------------

Install the requirements with bundle:

```bash
$ bundle install
```

You will also need to install the header files of the sqlite3 library
manually. Use your distribution's package manager.

Create a `tweetwatch` postgresql database with a `tweetwatch` user and password:

```SQL
CREATE DATABASE tweetwatch;
CREATE USER tweetwatch WITH PASSWORD tweetwatch;
GRANT ALL PRIVILEGES ON DATABASE tweetwatch TO tweetwatch;
```

Setup the database:

```bash
$ rake db_setup
```

You can also drop all the tables using `db_teardown` instead of `db_setup`.

You will need to edit the `tweetwatch.rb` file and set the list of `TOPICS` you want to watch as well as the Twitter API credentials. 

Run the twitter watcher process:

```bash
$ rake track_tweets
```

Run the web server:

```bash
$ rake server
```

Point your browser to `http://localhost:9292`.


Tests
-----

First create a test database (these are the default values which can be changed ffrom `database.yml`):

```SQL
CREATE DATABASE tweetwatch_test;
GRANT ALL PRIVILEGES ON DATABASE tweetwatch_test TO tweetwatch;
```

Run the tests:

```bash
$ bundle exec rspec
```
