Rails.application.routes.draw do

  get 'runners/show'

  resources :meets
  resources :calc_runs

  get 'admin' => 'admin#index'
  
  get 'calc_runs_show_all' => 'calc_runs#show_all'
  
  root :to => "calc_runs#index"
  
end
