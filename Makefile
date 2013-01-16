dependencies:
	@bundle install
	@cd test/railsapi/ ; bundle install

test:
	@echo "Running railsapi tests..."
	@cd test/railsapi/ && bundle exec rake

.PHONY: test dependencies
