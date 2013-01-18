RedisKit
========

[![Build Status](https://travis-ci.org/stvp/redis-kit.png?branch=master)](https://travis-ci.org/stvp/redis-kit) (master)

[![Build Status](https://travis-ci.org/stvp/redis-kit.png?branch=develop)](https://travis-ci.org/stvp/redis-kit) (develop)

[![Dependency Status](https://gemnasium.com/stvp/redis-kit.png)](https://gemnasium.com/stvp/redis-kit)

RedisKit is an (in-progress) gem that greatly simplifies the use of Redis in
Ruby in various environments.

Using RedisKit
--------------

Add the following to your `Gemfile`:

```ruby
gem "redis-kit"
```

And run `bundle install`. This will install the RedisKit gem as well as the
latest stable `redis` and `hiredis` gems.

Redis connections created by RedisKit automatically use [Hiredis][hiredis], the
the fast and reliable (and official) C client library for Redis.

[hiredis]: https://github.com/pietern/hiredis-rb

Rails
-----

If you're using Rails, RedisKit will include a [Rails
initializer](https://github.com/stvp/redis-kit/blob/master/lib/redis-kit/railtie.rb)
that will set up a Redis connection when your app loads. This Redis connection
is available via the `$redis` global.

The configuration for Redis can come from one of two places:

1. An environment variable like "REDIS_URL". Heroku add-ons like
   [RedisGreen][rg] use environment variables to supply your Redis URL.

2. A configuration file (`config/redis.yml`) containing a section for each
   environment with settings that will be passed straight to `Redis.new`:

    ```yaml
    development:
      url: redis://localhost:6379
    test:
      host: localhost
      port: 6380
      password: foobarbaz
    production:
      url: <%= ENV['REDIS_URL']%>
    ```

    This file will be passed through ERB, so you can include ERB tags as shown
    above under "production" to evaluate the configuration at runtime.

[rg]: http://redisgreen.net

If the environment variable doesn't exist, RedisKit will use the settings from
the config file.

Resque
------

Redis connections must be reconnected after a fork (e.g. when a Resque worker
processes a job). Resque handles its own Redis connection (`Resque.redis`).
However, if Resque is using a different connection than your main Redis
connection (`$redis`)

Support
-------

RedisKit officially supports the following Rubies:

* Ruby >= 1.9.2
* JRuby >= 1.7.0 (in 1.9 mode)
* Rubinius >= 1.2.0 (in 1.9 mode)

And the following libraries:

* Rails >= 3.0.0 (including Rails 4)
* Resque >= 1.6

Development
-----------

Set up and run tests with:

    make dependencies
    make test

TODO
----

* Add generators for common files
  * Resque initializer
  * Unicorn config (after fork hook)
* Under forking servers (Unicorn, Rainbows, Passenger), automatically
  re-establish the connection after forking.
* Under threaded servers, provide a connection pool of Redis connections.
* Under Sidekiq, provide a pool of Redis connections for your workers to use
  based on your Sidekiq settings (when Sidekiq's redis connection != your main
  connection)
* Ensure support for all servers:
    * Multi-Process, preforking: Unicorn, Rainbows, Passenger
    * Evented (suited for sinatra-synchrony): Thin, Rainbows, Zbatery
    * Threaded: Net::HTTP::Server, Threaded Mongrel, Puma, Rainbows, Zbatery, Thin[1]

