group :test do
  gem 'guard-rspec'

  guard 'rspec', :version => 2 do
    watch(%r{^spec/.+_spec\.rb$})
    watch('lib/mygem.rb')           { "spec" }
    watch(%r{^lib/mygem/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')    { "spec" }
  end
end

