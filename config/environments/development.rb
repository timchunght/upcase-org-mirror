Workshops::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  HOST = 'localhost:3000'
  config.action_mailer.default_url_options = { host: HOST }
  config.action_mailer.delivery_method = :test

  Paypal.sandbox = true
  PAYPAL_USERNAME = "dvtest_1274820363_biz_api1.thoughtbot.com"
  PAYPAL_PASSWORD = "1274820375"
  PAYPAL_SIGNATURE = "AVKfPIxQmv1Cx110eaST5hCDDRvIAHcHwza1R3BuWSImSagGLPnBY7v7"
  PAPERCLIP_STORAGE_OPTIONS = {
     storage: :s3,
     s3_credentials: "#{Rails.root}/config/s3.yml",
  }

  GITHUB_KEY = ENV['GITHUB_KEY']
  GITHUB_SECRET = ENV['GITHUB_SECRET']
end