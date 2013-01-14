# SecretTokenMigration

```
★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
★ WARNING: this is intended for maintenance. If your `secret_token` was compromised, REPLACE IT instead of using this ★
★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
```

The most basic convention for maintaining session state in Rails apps has been this:

``` ruby
def login(user)
  session[:user_id] = user.id
end
```

The Rails session is just a cookie that includes a signed digest of the contents, using a `secret_token`.

But sometimes you need to change your `secret_token`, which would in these most basic cases logout most of your users.

This gem provides a graceful way to change your `secret_token` without logging out **most** of your active users.

## Example Situations 

* You use the same `secret_token` in all of your environments, but decide that you want to separate them.
* Your `secret_token` was found logged in some third-party software, **but** you have no evidence that it was compromised, and want to change it.
* Regular swapping of `secret_token` as a precaution.

## How It Works

Regularly, you set a `MyApp::Application.config.secret_token` in your Rails app. By requiring this gem, setting `secret_token` to a new value, and including a `MyApp::Application.config.deprecated_secret_token` set to the old value, users with sessions digested with the old value will be gracefully transitioned to a session digested with the new value. When you feel comfortable that most active users have transitioned, you can remove this gem and the `deprecated_secret_token` config variable.

## Installation

Add this line to your application's Gemfile:

    gem 'secret_token_migration', '~> 0.0.4'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secret_token_migration

## Usage

1. In your `config/initializers/secret_token.rb` file, set the `secret_token` to a new, secure value.
2. Add this line:
  `MyApp::Application.config.deprecated_secret_token = [THE_OLD_SECRET_TOKEN_VALUE]`
3. Optionally, add some instrumentation (described below) to track how many users have been transitioned.

## Instrumentation

You can also subscribe to `MessageVerifier` digesting to track when a deprecated secret_token is used (eg, for graphing):

``` ruby
ActiveSupport::Notifications.subscribe "deprecated_secret.active_support" do
  Rails.logger.info "deprecated secret_token used"
end
```

## Reminder

If your `secret_token` **has** been compromised, don't bother with this library. You need to switch it ASAP and deal with all users being logged out.


