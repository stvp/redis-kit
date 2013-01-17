RedisKit
========

[![Build Status](https://travis-ci.org/stvp/redis-kit.png?branch=master)](undefined) (master)

[![Build Status](https://travis-ci.org/stvp/redis-kit.png?branch=develop)](undefined) (develop)

[![Dependency Status](https://gemnasium.com/stvp/redis-kit.png)](https://gemnasium.com/stvp/redis-kit)

RedisKit is an (in-progress) gem that greatly simplifies the use of Redis in
Ruby in various environments.

Running tests
-------------

    make dependencies
    make test

TODO
----

* In Rails apps, automatically set up a Redis connection based on settings in
  `config/redis.yml` or an environment variable (`REDIS_URL`).
* Under forking servers (Unicorn, Rainbows, Passenger), automatically
  re-establish the connection after forking.
* Under threaded servers, provide a connection pool of Redis connections.
* Under Resque, re-establish Redis connections for jobs that use Redis.  (Resque
  manages its own connection to Redis but does not handle connections used by
  your jobs.)
* Under Sidekiq, provide a pool of Redis connections for your workers to use
  based on your Sidekiq settings.
* Ensure support for all servers:
    * Multi-Process, preforking: Unicorn, Rainbows, Passenger
    * Evented (suited for sinatra-synchrony): Thin, Rainbows, Zbatery
    * Threaded: Net::HTTP::Server, Threaded Mongrel, Puma, Rainbows, Zbatery, Thin[1]

