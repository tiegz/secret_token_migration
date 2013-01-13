ENV["RAILS_ENV"] = "test"

require 'test/unit'
require 'rails'
require 'active_support/test_case'
require 'action_controller/test_case'
require 'action_dispatch/testing/integration'
require 'shoulda'
require 'secret_token_migration'

# the railtie logic
require 'secret_token_migration/railties/application'
require 'secret_token_migration/action_dispatch/cookies'
require 'secret_token_migration/active_support/message_verifier'
