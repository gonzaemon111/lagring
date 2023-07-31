class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions, comment: 'サブスクリプション' do |t|
      t.references :user, null: false, foreign_key: true, comment: 'ユーザー'
      t.string :name, null: false, comment: 'サブスクリプション名'
      t.text :memo, comment: 'メモ'
      t.integer :price, default: 0, null: false, comment: '金額'
      t.string :repeat_frequency, default: 'none', null: false, comment: '繰り返し頻度'
      t.string :image_url, comment: '画像URL'
      t.datetime :started_at, comment: '開始日時'
      t.datetime :finished_at, comment: '終了日時'

      t.timestamps
    end
  end
end
