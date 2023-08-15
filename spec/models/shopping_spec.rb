# == Schema Information
#
# Table name: shoppings
#
#  id                        :bigint           not null, primary key
#  image_url(画像URL)        :string
#  is_bought(買ったかどうか) :boolean          default(FALSE), not null
#  memo(メモ)                :text
#  name(買うもの)            :string(255)      default(""), not null
#  price(金額)               :integer          default(0), not null
#  shop(店)                  :string
#  url(URL)                  :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id(ユーザー)         :bigint           not null
#
# Indexes
#
#  index_shoppings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Shopping, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'db' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:image_url).of_type(:string) }
    it { is_expected.to have_db_column(:url).of_type(:string) }
    it { is_expected.to have_db_column(:shop).of_type(:string) }
    it { is_expected.to have_db_column(:memo).of_type(:text) }
    it { is_expected.to have_db_column(:price).of_type(:integer) }
    it { is_expected.to have_db_column(:is_bought).of_type(:boolean) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:user_id) }
  end

  context 'When Association' do
    it { is_expected.to belong_to(:user).class_name('::User') }
  end
end
