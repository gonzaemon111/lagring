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
FactoryBot.define do
  factory :shopping, class: ::Shopping do
    association :user
    name { 'ティッシュ' }
    url { 'https://amzn.asia/d/d3I41Ej' }
    image_url { 'https://m.media-amazon.com/images/I/71j+nzsS4DS._AC_SX679_.jpg' }
    shop { 'Amazon' }
    is_bought { false }
    memo { 'メモ' }
    price { 3_000 }
  end
end
