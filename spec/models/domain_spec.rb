# == Schema Information
#
# Table name: domains
#
#  id                          :bigint           not null, primary key
#  account_name(アカウント名)  :string
#  is_canceled(解約済み)       :boolean
#  memo(メモ)                  :text
#  name(ドメイン名)            :string
#  next_updated_at(更新予定日) :datetime
#  provider(プロバイダ)        :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  user_id(ユーザーID)         :bigint           not null
#
# Indexes
#
#  index_domains_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Domain, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:provider) }
  end

  context 'db' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:provider).of_type(:string) }
    it { is_expected.to have_db_column(:memo).of_type(:text) }
    it { is_expected.to have_db_column(:account_name).of_type(:string) }
    it { is_expected.to have_db_column(:is_canceled).of_type(:boolean) }
    it { is_expected.to have_db_column(:next_updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:user_id) }
  end

  context 'When Association' do
    it { is_expected.to belong_to(:user).class_name('::User') }
  end
end
