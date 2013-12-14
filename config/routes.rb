BowlingGame::Application.routes.draw do
  root 'balls#new'
  resources :balls, only: [:new, :create]
end
