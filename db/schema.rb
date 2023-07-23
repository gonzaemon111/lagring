# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_22_075613) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "domains", comment: "ドメイン", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.string "name", comment: "ドメイン名"
    t.string "provider", comment: "プロバイダ"
    t.datetime "next_updated_at", comment: "更新予定日"
    t.string "account_name", comment: "アカウント名"
    t.boolean "is_canceled", comment: "解約済み"
    t.text "memo", comment: "メモ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_domains_on_user_id"
  end

  create_table "tasks", comment: "タスク", force: :cascade do |t|
    t.string "name", comment: "タスク名"
    t.string "category_name", comment: "カテゴリ名"
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.datetime "finished_at", comment: "終了日時"
    t.datetime "deadline", comment: "締切"
    t.text "memo", comment: "メモ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", comment: "ユーザーID", force: :cascade do |t|
    t.string "provider", comment: "プロバイダ"
    t.string "name", comment: "ユーザー名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.string "email"
    t.index ["provider", "email"], name: "index_users_on_provider_and_email", unique: true
  end

  add_foreign_key "domains", "users"
  add_foreign_key "tasks", "users"
end
