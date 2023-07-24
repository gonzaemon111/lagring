# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  email                :string
#  name(ユーザー名)     :string
#  picture              :string
#  provider(プロバイダ) :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_provider_and_email  (provider,email) UNIQUE
#
class User < ApplicationRecord
  has_many :domains, class_name: '::Domain', dependent: :destroy
  has_many :tasks, class_name: '::Task', dependent: :destroy

  validates :provider, presence: true
  validates :name, presence: true

  def generate_token
    ::AccessTokenService.new.generate_token({ email:, provider: })
  end
end
