Playerpool::Application.routes.draw do
  resources :users
  resources :games
  resources :players
  resources :teams
  
  root :to => "player_pool#index"
end
