# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  name(ユーザー名)     :string
#  provider(プロバイダ) :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:provider) }
  end

  context 'db' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:provider).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  context 'When Association' do
    it { is_expected.to have_many(:domains).dependent(:destroy).class_name('::Domain') }
  end
end
