task :add_password_to_oauth_accounts => :environment do

  User.where('uid is not null').each do |u|
    u.set_oauth_password
    u.save
    puts u.email
  end

end
