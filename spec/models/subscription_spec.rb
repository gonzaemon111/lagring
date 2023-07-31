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
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'db' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:repeat_frequency).of_type(:string) }
    it { is_expected.to have_db_column(:memo).of_type(:text) }
    it { is_expected.to have_db_column(:price).of_type(:integer) }
    it { is_expected.to have_db_column(:started_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:finished_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:user_id) }
  end

  context 'When Association' do
    it { is_expected.to belong_to(:user).class_name('::User') }
  end
end
