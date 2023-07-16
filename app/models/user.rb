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
class User < ApplicationRecord
  validates :provider, presence: true
  validates :name, presence: true
end
