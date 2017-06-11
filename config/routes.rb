Rails.application.routes.draw do

  get 'runners/show'

  resources :meets
  resources :calc_runs

  get 'admin' => 'admin#index'
  
  root :to => "calc_runs#index"
  
end
