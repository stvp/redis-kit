easy-redis
==========

Master: [![Build Status](https://travis-ci.org/stvp/easy-redis.png?branch=master)](undefined) Develop: [![Build Status](https://travis-ci.org/stvp/easy-redis.png?branch=develop)](undefined)

easy-redis is an (in-progress) gem that greatly simplifies the use of Redis in
Ruby. It will support the following:

* In Rails apps, easy-redis will automatically set up a Redis connection based
  on settings in `config/redis.yml` or an environment variable (`REDIS_URL`).
* Under forking servers (Unicorn, Rainbows, Passenger), it will automatically
  re-establish the connection after forking.
* Under threaded servers, it will provide a connection pool of Redis
  connections.
* Under Resque, it will re-establish Redis connections for jobs that use Redis.
  (Resque manages its own connection to Redis but does not handle connections
  used by your jobs.)
* Under Sidekiq, it will provide a pool of Redis connections for your workers to
  use based on your Sidekiq settings.

Running tests
-------------

    make dependencies
    make

TODO
----

* Handle Resque forks (for Redis access inside a job)
* Add connection pool for Sidekiq
* Support and test under various types of servers:
    * Multi-Process, preforking: Unicorn, Rainbows, Passenger
    * Evented (suited for sinatra-synchrony): Thin, Rainbows, Zbatery
    * Threaded: Net::HTTP::Server, Threaded Mongrel, Puma, Rainbows, Zbatery, Thin[1]

