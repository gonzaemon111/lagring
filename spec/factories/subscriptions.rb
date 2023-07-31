# == Schema Information
#
# Table name: subscriptions
#
#  id                             :bigint           not null, primary key
#  finished_at(終了日時)          :datetime
#  image_url(画像URL)             :string
#  memo(メモ)                     :text
#  name(サブスクリプション名)     :string           not null
#  price(金額)                    :integer          default(0), not null
#  repeat_frequency(繰り返し頻度) :string           default("none"), not null
#  started_at(開始日時)           :datetime
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  user_id(ユーザー)              :bigint           not null
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :subscription, class: ::Subscription do
    association :user
    name { 'Netflix' }
    price { 990 }
    repeat_frequency { 'month' }
    started_at { '2022-07-01 23:03:42' }
    finished_at { '2023-08-01 23:03:42' }
    image_url { 'https://images.ctfassets.net/4cd45et68cgf/Rx83JoRDMkYNlMC9MKzcB/2b14d5a59fc3937afd3f03191e19502d/Netflix-Symbol.png?w=700&h=456' }
    memo { 'メモ' }
  end
end
