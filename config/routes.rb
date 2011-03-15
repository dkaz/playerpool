Playerpool::Application.routes.draw do
  resources :games, :teams, :players
  resources :users do
    post :add_player, :on => :member
  end
  
  root :to => "player_pool#index"
end
