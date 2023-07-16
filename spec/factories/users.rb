# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  name(ユーザー名)     :string
#  provider(プロバイダ) :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :user, class: ::User do
    provider { 'Github' }
    name { 'テストユーザー' }
  end
end
