module ActionDispatch
  class Cookies
    DEPRECATED_TOKEN_KEY = "action_dispatch.deprecated_secret_token".freeze    

    class CookieJar
      class << self
        def build_with_deprecated_secret(request)
          build_without_deprecated_secret(request).tap do |hash|
            hash.instance_variable_set(:@deprecated_secret, request.env[DEPRECATED_TOKEN_KEY])
          end
        end
        alias_method_chain :build, :deprecated_secret # apologies
      end

      def signed
        @signed ||= if @deprecated_secret
          ActionDispatch::Cookies::SignedCookieWithDeprecatedTokenJar.new(self, @secret, {:deprecated_secret => @deprecated_secret})
        else
          ActionDispatch::Cookies::SignedCookieJar.new(self, @secret)
        end
      end
    end
    
    class SignedCookieWithDeprecatedTokenJar < ActionDispatch::Cookies::SignedCookieJar
      def initialize(parent_jar, secret, options={})
        ensure_secret_secure(secret)
        ensure_secret_secure(options[:deprecated_secret])
        @parent_jar = parent_jar
        @verifier   = ActiveSupport::MessageVerifier.new(secret, options)
        @verifier.instance_variable_set(:@deprecated_secret, options[:deprecated_secret])
      end
    end
  end
end