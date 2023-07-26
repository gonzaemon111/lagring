Rails.application.routes.draw do
  namespace :api do
    resources :users, only: %i[show create]
    resources :domains, only: %i[index show create destroy update]
    resources :tasks, only: %i[index show create destroy update]
    resources :daily_necessities, only: %i[index show create destroy update]
  end

  get 'health', to: 'health#check'
  root 'health#check'
end
