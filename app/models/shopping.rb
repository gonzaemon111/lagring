# == Schema Information
#
# Table name: shoppings
#
#  id                        :bigint           not null, primary key
#  image_url(画像URL)        :string
#  is_bought(買ったかどうか) :boolean          default(FALSE), not null
#  memo(メモ)                :text
#  name(買うもの)            :string(255)      default(""), not null
#  price(金額)               :integer          default(0), not null
#  shop(店)                  :string
#  url(URL)                  :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id(ユーザー)         :bigint           not null
#
# Indexes
#
#  index_shoppings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Shopping < ApplicationRecord
  belongs_to :user, class_name: '::User'

  validates :name, presence: true
end
