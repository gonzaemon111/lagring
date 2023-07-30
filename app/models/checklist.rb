# == Schema Information
#
# Table name: checklists
#
#  id                             :bigint           not null, primary key
#  date(日付)                     :date
#  memo(メモ)                     :text
#  name(チェック名)               :string
#  repeat_frequency(繰り返し頻度) :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  user_id(ユーザー)              :bigint           not null
#
# Indexes
#
#  index_checklists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Checklist < ApplicationRecord
  extend ::Enumerize

  belongs_to :user, class_name: '::User'

  validates :name, presence: true
  validates :repeat_frequency, presence: true

  enumerize :repeat_frequency, in: {
    month: :month,
    week: :week,
    two_week: :two_week,
    day: :day,
    none: :none
  }, predicates: true, scope: true, default: :none
end
