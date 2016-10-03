require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root 'musics#index'

  resources :musics, only: [:index, :update] do
    post 'parse', to: 'musics#parse', on: :collection
  end
end
