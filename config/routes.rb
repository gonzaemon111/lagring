Rails.application.routes.draw do
  namespace :api do
    resources :users, only: %i[show create], defaults: { format: :json }
    resources :domains, only: %i[index show create destroy update], defaults: { format: :json }
    resources :tasks, only: %i[index show create destroy update], defaults: { format: :json }
    resources :daily_necessities, only: %i[index show create destroy update], defaults: { format: :json }
    resources :checklists, only: %i[index show create destroy update], defaults: { format: :json }
    resources :subscriptions, only: %i[index show create destroy update], defaults: { format: :json }
  end

  get 'health', to: 'health#check'
  get '*not_found', to: 'application#routing_error'

  root 'health#check'
end
