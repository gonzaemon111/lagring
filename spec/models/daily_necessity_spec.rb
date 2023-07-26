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
require 'rails_helper'

RSpec.describe DailyNecessity, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'db' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { is_expected.to have_db_column(:memo).of_type(:text) }
    it { is_expected.to have_db_column(:image_url).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:user_id) }
  end

  context 'When Association' do
    it { is_expected.to belong_to(:user).class_name('::User') }
  end
end
