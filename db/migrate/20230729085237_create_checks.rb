class CreateChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :checklists, comment: 'チェック' do |t|
      t.references :user, null: false, foreign_key: true, comment: 'ユーザー'
      t.string :name, comment: 'チェック名'
      t.date :date, comment: '日付'
      t.string :repeat_frequency, comment: '繰り返し頻度'
      t.text :memo, comment: 'メモ'

      t.timestamps
    end
  end
end
