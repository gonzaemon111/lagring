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
class Task < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
end
