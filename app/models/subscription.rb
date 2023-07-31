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
class Subscription < ApplicationRecord
  extend ::Enumerize

  belongs_to :user, class_name: '::User'

  validates :name, presence: true

  enumerize :repeat_frequency, in: {
    year: :year,
    month: :month,
    week: :week,
    two_week: :two_week,
    day: :day,
    none: :none
  }, predicates: true, scope: true, default: :none
end
