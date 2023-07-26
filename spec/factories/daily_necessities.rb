# == Schema Information
#
# Table name: daily_necessities
#
#  id                 :bigint           not null, primary key
#  image_url(画像URL) :string
#  memo(メモ)         :text
#  name(名前)         :string           not null
#  quantity(個数)     :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id(ユーザー)  :bigint           not null
#
# Indexes
#
#  index_daily_necessities_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :daily_necessity, class: ::DailyNecessity do
    association :user
    name { 'トイレットペーパー' }
    quantity { 0 }
    image_url { 'https://www.jamble.co.jp/upload/save_image/63369_01.jpg' }
    memo { 'メモ' }
  end
end
