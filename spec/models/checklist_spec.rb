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
require 'rails_helper'

RSpec.describe Checklist, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'db' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:date).of_type(:date) }
    it { is_expected.to have_db_column(:repeat_frequency).of_type(:string) }
    it { is_expected.to have_db_column(:memo).of_type(:text) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:user_id) }
  end

  context 'When Association' do
    it { is_expected.to belong_to(:user).class_name('::User') }
  end
end
