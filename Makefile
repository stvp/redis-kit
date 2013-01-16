dependencies:
	@bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_1 bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_2 bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_head bundle install

test:
	@echo "=========================="
	@echo "Running Rails 3.1 tests..."
	@echo "=========================="
	@cd test/railsapi/ && BUNDLE_GEMFILE=Gemfile.rails_3_1 bundle exec rake
	@echo ""
	@echo "=========================="
	@echo "Running Rails 3.2 tests..."
	@echo "=========================="
	@cd test/railsapi/ && BUNDLE_GEMFILE=Gemfile.rails_3_2 bundle exec rake
	@echo ""
	@echo "==========================="
	@echo "Running Rails HEAD tests..."
	@echo "==========================="
	@cd test/railsapi/ && BUNDLE_GEMFILE=Gemfile.rails_head bundle exec rake

.PHONY: test dependencies
