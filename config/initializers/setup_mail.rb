
email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/mail.yml"))
ActionMailer::Base.smtp_settings = email_settings[Rails.env]["smtp_setttings"] unless email_settings[Rails.env].nil?
ActionMailer::Base.default_options = email_settings[Rails.env]["default_options"].to_hash  
