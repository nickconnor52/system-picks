Rails.application.routes.draw do
  scope path: 'api' do
    resources :teams do
      post "weekly_stats" => "stats#show"
      resources :stats, :except => :show
    end
    resources :matchups
  end

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
