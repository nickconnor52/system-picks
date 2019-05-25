Rails.application.routes.draw do
  scope path: 'api' do
    resources :teams
  end

  resources :matchups
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
