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
FactoryBot.define do
  factory :user, class: ::User do
    provider { 'Github' }
    name { 'テストユーザー' }
    email { ::Faker::Internet.email }
  end
end
