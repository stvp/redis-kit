# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redisgreen/version"

Gem::Specification.new do |s|
  s.name        = "redisgreen"
  s.version     = RedisGreen::VERSION
  s.authors     = ["Tyson Tate"]
  s.email       = ["tyson@stovepipestudios.com"]
  s.homepage    = "http://github.com/stvp/redisgreen-rb"
  s.summary     = "simple redis init"
  s.description = "simple redis init for rails projects"

  s.rubyforge_project = "redisgreen"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "redis"
  s.add_runtime_dependency "hiredis"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-test"
  # s.add_development_dependency "pry"
end
