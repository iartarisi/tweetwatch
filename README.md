tweetstream
===========


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
