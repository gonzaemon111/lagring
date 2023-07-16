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
  pending "add some examples to (or delete) #{__FILE__}"
end
