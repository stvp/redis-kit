0.0.2
=====

* Add support for Ruby 2.0.0.
* Drop support for Rails < 3.2 and Ruby < 1.9.3.
* Fix bug whereby redis-kit would clobber Resque hooks, replacing them with its
  own.
* Allow MockRedis as a back-end (for tests).

0.0.1
=====

* Initial release with support for:
    * Rails 3.0, 3.1, 3.2
    * Ruby 1.9.1, 1.9.2, 1.9.3, 2.0
    * JRuby in 1.9 mode
    * Rubinius in 1.9 mode

