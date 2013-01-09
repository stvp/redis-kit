redisgreen
==========

Running tests:

    cd test/railsapi
    bundle install
    ruby -Itest test/unit/redisgreen_test.rb

TODO
----

* Handle forking servers (Unicorn, etc.)
* Handle Resque forks (for redis access inside a job)

