require_relative '../test_helper'

class RailsApplicationTest < ActiveSupport::TestCase
  context "a rails application" do
    subject do
      Class.new(Rails::Application).tap do |app|
        app.config.deprecated_secret_token = "b"*128
        app.config.secret_token = "a"*128
      end
    end

    teardown do
      Rails.application = nil
    end

    should "have secret_token" do
      assert subject.env_config["action_dispatch.secret_token"].present?
      assert_equal 128, subject.env_config["action_dispatch.secret_token"].length
    end

    should "have deprecated_secret_token" do
      assert subject.env_config["action_dispatch.deprecated_secret_token"].present?
      assert_equal 128, subject.env_config["action_dispatch.deprecated_secret_token"].length
    end
  end
end
