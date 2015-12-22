class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: %i(facebook vkontakte)

  has_many :identities, dependent: :destroy

  validates :full_name, presence: true
end
