Rails.application.routes.draw do
  namespace :api do
    resources :users, only: %i[index show create destroy update]
    resources :domains, only: %i[index show create destroy update]
  end

  get 'health', to: 'health#check'
  root 'health#check'
end
