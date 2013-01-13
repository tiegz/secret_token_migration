require 'secret_token_migration'

module SecretTokenMigration
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'secret_token_migration.insert_into_application' do
      ActiveSupport.on_load :before_configuration do
        SecretTokenMigration::Railtie.insert
      end
    end
  end

  class Railtie
    def self.insert
      require 'railties/application'
      require 'action_dispatch/cookies'
      require 'active_support/message_verifier'
    end
  end
end
