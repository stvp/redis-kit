# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis-kit/version"

Gem::Specification.new do |s|
  s.name        = "redis-kit"
  s.version     = RedisKit::VERSION
  s.authors     = ["Tyson Tate"]
  s.email       = ["tyson@stovepipestudios.com"]
  s.homepage    = "http://github.com/stvp/redis-kit-rb"
  s.summary     = "simple redis init"
  s.description = "simple redis init for rails projects"

  s.rubyforge_project = "redis-kit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "redis", "~> 3.0.0"
  s.add_dependency "hiredis", "~> 0.4.0" if RUBY_ENGINE != "jruby"
  s.add_dependency "mock_redis", "~> 0.6.0"
  s.add_development_dependency "rake", "~> 10.0.0"
  s.add_development_dependency "rb-fsevent", "~> 0.9.0"
  s.add_development_dependency "guard", "~> 1.6.0"
  s.add_development_dependency "guard-minitest", "~> 0.5.0"
end

