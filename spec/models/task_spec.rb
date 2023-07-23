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
require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'db' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:category_name).of_type(:string) }
    it { is_expected.to have_db_column(:memo).of_type(:text) }
    it { is_expected.to have_db_column(:deadline).of_type(:datetime) }
    it { is_expected.to have_db_column(:finished_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:user_id) }
  end

  context 'When Association' do
    it { is_expected.to belong_to(:user).class_name('::User') }
  end
end
