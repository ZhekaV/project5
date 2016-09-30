Rails.application.routes.draw do
  root 'musics#index'
  resources :musics, only: [:index, :update] do
    post 'parse', to: 'musics#parse', on: :collection
  end
end
