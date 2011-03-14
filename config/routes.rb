Playerpool::Application.routes.draw do
  resources :games
  resources :players
  resources :teams
  
  root :to => "player_pool#index"
end
