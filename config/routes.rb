Rails.application.routes.draw do

  resources :meets
  resources :calc_runs

  get 'admin' => 'admin#index'
  
  root :to => "calc_runs#index"
  
end
