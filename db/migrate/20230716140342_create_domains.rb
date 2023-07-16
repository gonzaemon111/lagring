class CreateDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :domains, comment: 'ドメイン' do |t|
      t.references :user, null: false, foreign_key: true, comment: 'ユーザーID'
      t.string :name, null: false, comment: 'ドメイン名'
      t.string :provider, null: false, comment: 'プロバイダ'
      t.datetime :next_updated_at, comment: '更新予定日'
      t.string :account_name, null: false, comment: 'アカウント名'
      t.boolean :is_canceled, default: false, null: false, comment: '解約済み'
      t.text :memo, comment: 'メモ'

      t.timestamps
    end
  end
end
