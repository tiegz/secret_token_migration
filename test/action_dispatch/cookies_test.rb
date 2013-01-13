require_relative '../test_helper'

class CookiesTest < ActiveSupport::TestCase
  context "with only regular token" do
    setup do
      @old_cookies = ActionDispatch::Cookies::CookieJar.build(ActionController::TestRequest.new({
        "action_dispatch.secret_token" => "old" * 50
      }))

      @deprecated_cookies = ActionDispatch::Cookies::CookieJar.build(ActionController::TestRequest.new({
        "action_dispatch.secret_token" => "new" * 50,
        "action_dispatch.deprecated_secret_token" => "old" * 50
      }))

      @new_cookies = ActionDispatch::Cookies::CookieJar.build(ActionController::TestRequest.new({
        "action_dispatch.secret_token" => "new" * 50,
      }))

      @old_cookies.signed["foo"] = "bar"
    end

    should "use correct class for signed cookies" do
      assert_equal ActionDispatch::Cookies::SignedCookieJar, 
        @old_cookies.signed.class
      assert_equal ActionDispatch::Cookies::SignedCookieWithDeprecatedTokenJar, 
        @deprecated_cookies.signed.class
      assert_equal ActionDispatch::Cookies::SignedCookieJar, 
        @new_cookies.signed.class
    end

    should "read/write the old value with a deprecated token cookie" do
      @deprecated_cookies["foo"] = @old_cookies["foo"] # without 'signed', fetches the digested value
      assert_equal "bar", @deprecated_cookies.signed["foo"]
    end

    should "not read/write the old value with a new token cookie" do
      @new_cookies["foo"] = @old_cookies["foo"] # without 'signed', fetches the digested value
      assert_equal nil, @new_cookies.signed["foo"]
    end
  end
end