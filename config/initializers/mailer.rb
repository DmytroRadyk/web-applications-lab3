Rails.application.configure do
  host = ENV.fetch("APP_HOST", ENV.fetch("RENDER_EXTERNAL_HOSTNAME", "localhost"))
  config.action_mailer.default_url_options = { host: host, protocol: Rails.env.production? ? "https" : "http" }
  config.action_mailer.default_url_options[:port] = 3001 if Rails.env.development?
  if Rails.env.production? && ENV["SMTP_ADDRESS"].present?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV["SMTP_ADDRESS"], port: ENV.fetch("SMTP_PORT", 587).to_i,
      user_name: ENV["SMTP_USERNAME"], password: ENV["SMTP_PASSWORD"],
      authentication: :plain, enable_starttls_auto: true
    }
  end
end
