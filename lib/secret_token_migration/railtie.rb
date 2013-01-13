require 'secret_token_migration'

module SecretTokenMigration
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'secret_token_migration.insert_into_application' do
      ActiveSupport.on_load :before_configuration do
        SecretTokenMigration::Railtie.insert
      end
    end

    def self.insert
      require 'secret_token_migration/railties/application'
      require 'secret_token_migration/action_dispatch/cookies'
      require 'secret_token_migration/active_support/message_verifier'
    end
  end
end
