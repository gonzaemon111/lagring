class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, comment: 'ユーザーID' do |t|
      t.string :provider, null: false, comment: 'プロバイダ'
      t.string :name, null: false, comment: 'ユーザー名'

      t.timestamps
    end
  end
end
