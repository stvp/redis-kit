dependencies:
	@bundle install
	@bundle update redis hiredis
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_2 bundle
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_2 bundle
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_4_1 bundle
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_4_1 bundle

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
	@echo "=================================="
	@echo "Running tests against Rails 4.1..."
	@echo "=================================="
	@cd test/railsapi/ && BUNDLE_GEMFILE=Gemfile.rails_4_1 bundle exec rake

.PHONY: test ci dependencies
