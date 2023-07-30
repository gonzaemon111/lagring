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
FactoryBot.define do
  factory :checklist, class: ::Checklist do
    association :user
    name { 'トイレ掃除' }
    date { '2023-08-01' }
    repeat_frequency { 'none' }
    memo { '' }
  end
end
