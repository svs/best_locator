task :add_password_to_oauth_accounts => :environment do

  User.where('uid is not null').each do |u|
    u.password = u.password_confirmation = "#{u.uid}--#{ENV['OAUTH_PASSWORD_SALT']}"
    u.save
    puts u.email
  end

end
