module Rails
  class Application
    attr_accessor :deprecated_secret_token

    def env_config_with_deprecated_secret_token
      @env_config ||= env_config_without_deprecated_secret_token.merge({
        "action_dispatch.deprecated_secret_token" => config.deprecated_secret_token
      })
    end
    alias_method_chain :env_config, :deprecated_secret_token
  end
end