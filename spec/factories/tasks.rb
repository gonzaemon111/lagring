# == Schema Information
#
# Table name: tasks
#
#  id                        :bigint           not null, primary key
#  category_name(カテゴリ名) :string
#  deadline(締切)            :datetime
#  finished_at(終了日時)     :datetime
#  memo(メモ)                :text
#  name(タスク名)            :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id(ユーザー)         :bigint           not null
#
# Indexes
#
#  index_tasks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :task, class: ::Task do
    association :user
    name { 'トイレ掃除' }
    finished_at { '2023-07-16 23:03:42' }
    deadline { '2023-07-16 23:03:42' }
    category_name { '掃除' }
    memo { 'メモ' }
  end
end
