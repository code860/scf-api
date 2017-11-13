Rails.application.routes.draw do
  constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do
        resources :github_events, only: [:index, :show]
        resources :github_users, only: [:show]
      end
    end
  end
end
