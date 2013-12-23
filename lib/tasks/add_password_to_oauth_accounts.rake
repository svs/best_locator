task :add_password_to_oauth_accounts => :environment do

  User.where('uid is not null').each do |u|
    u.password = u.password_confirmation = Digest::SHA1.hexdigest("#{auth.uid}--#{ENV['OAUTH_PASSWORD_SALT']}")[0..9]
    u.save
    puts u.email
  end

end
