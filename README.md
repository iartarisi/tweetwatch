tweetstream
===========

Tweetstream allows you to watch a list of Twitter topics in real time
and display the N number of most retweeted tweets in the last N minutes.

Installation
------------

Install the requirements with bundle:

```bash
$ bundle install
```

You will also need to install the header files of the sqlite3 library
manually. Use your distribution's package manager.

Setup the database:

```bash
$ bundle exec ruby database.rb setup
```

You can also drop all the tables using `teardown` instead of `setup`.

You will need to edit the `tweetstream.rb` file and set the list of `TOPICS` you want to watch as well as the Twitter API credentials. 
