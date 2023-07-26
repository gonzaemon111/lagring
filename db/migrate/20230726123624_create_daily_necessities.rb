class CreateDailyNecessities < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_necessities, comment: '日用品' do |t|
      t.references :user, null: false, foreign_key: true, comment: 'ユーザー'
      t.string :name, null: false, comment: '名前'
      t.integer :quantity, default: 0, null: false, comment: '個数'
      t.string :image_url, comment: '画像URL'
      t.text :memo, comment: 'メモ'

      t.timestamps
    end
  end
end
