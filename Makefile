dependencies:
	@bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_0 bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_1 bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_3_2 bundle install
	@cd test/railsapi/ ; BUNDLE_GEMFILE=Gemfile.rails_head bundle install

ci:
	cd test/railsapi/ ; bundle exec rake

test:
	@echo "=================================="
	@echo "Running tests against Rails 3.0..."
	@echo "=================================="
	@cd test/railsapi/ && BUNDLE_GEMFILE=Gemfile.rails_3_0 bundle exec rake
	@echo ""
	@echo "=================================="
	@echo "Running tests against Rails 3.1..."
	@echo "=================================="
	@cd test/railsapi/ && BUNDLE_GEMFILE=Gemfile.rails_3_1 bundle exec rake
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
