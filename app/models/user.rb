class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable

  before_validation :verify_token_exists

  has_many :trips

  def self.from_omniauth(auth)
    binding.pry
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
      user.email = auth.info.email
      user.name = [auth.info.first_name, auth.info.last_name].join(" ")
      user.password = user.password_confirmation = Digest::SHA1.hexdigest("#{auth.uid}--#{ENV['OAUTH_PASSWORD_SALT']}")[0..9]
    end
  end


  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def has_live_trip?
    self.trips.where(:status => "started").count > 0
  end


  private

  def verify_token_exists
    self.auth_token ||= SecureRandom::urlsafe_base64
  end

end
