Playerpool::Application.routes.draw do
  resources :teams, :players
  resources :games, :except => :destroy
  resources :users do
    post :add_player, :on => :member
  end
  
  root :to => "player_pool#index"
end
