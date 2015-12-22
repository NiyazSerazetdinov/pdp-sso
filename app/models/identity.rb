class Identity < ActiveRecord::Base
  belongs_to :user

  validates :uid, :provider, :user_id, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.find_by_omniauth(auth, user)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |identity|
      identity.provider = auth.provider
      identity.uid = auth.uid
      identity.user = user || User.where(email: auth.info.email).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token
        user.full_name = auth.info.name || auth.info.email
      end
    end
  end
end
