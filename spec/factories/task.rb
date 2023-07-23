FactoryBot.define do
  factory :task, class: ::Task do
    association :user
    name { 'トイレ掃除' }
    finished_at { '2023-07-16 23:03:42' }
    deadline { '2023-07-16 23:03:42' }
    category_name { '掃除' }
    memo { 'メモ' }
  end
end
