Rails.application.routes.draw do
  scope path: 'api' do
    resources :teams do
      post "weekly_stats" => "stats#show"
      resources :stats, :except => :show
    end
    resources :matchups do
      get "get_system_spread", on: :member
      post "refresh_system_spread", on: :member
    end

    post 'schedule/add_weekly_matchups', to: 'schedule#add_weekly_matchups'

    resources :users

  # Authentication Routes
    post 'refresh', controller: :refresh, action: :create
    post 'signin', controller: :signin, action: :create
    post 'signup', controller: :signup, action: :create
    delete 'signin', controller: :signin, action: :destroy


    namespace :scrape do
      post 'stat_scraper' => 'stat_generation#scrape'
      get 'fetch_schedule' => 'schedule_fetch#fetch'
    end
  end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
