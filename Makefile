dependencies:
	@bundle install
	@bundle update redis hiredis
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_2 bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_2 bundle update redis hiredis rails
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_head bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_head bundle update redis hiredis rails

ci:
	bundle exec rake
	cd test/railsapi/ ; bundle exec rake

test:
	@echo "======================"
	@echo "Running base gem tests"
	@echo "======================"
	@bundle exec rake
	@echo ""
	@echo "=================================="
	@echo "Running tests against Rails 3.2..."
	@echo "=================================="
	@cd test/railsapi/ && BUNDLE_GEMFILE=Gemfile.rails_3_2 bundle exec rake
	@echo ""
	@echo "==================================="
	@echo "Running tests against Edge Rails..."
	@echo "==================================="
	@cd test/railsapi/ && BUNDLE_GEMFILE=Gemfile.rails_head bundle exec rake

.PHONY: test ci dependencies
