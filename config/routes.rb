Rails.application.routes.draw do

  get 'power_ranking/show'

  get 'runners/show'

  resources :meets
  resources :calc_runs

  get 'admin' => 'admin#index'
  
  get 'calc_runs_show_all' => 'calc_runs#show_all'
  
  get 'power_rankings' => 'power_rankings#show'
  
  root :to => "calc_runs#index"
  
end
