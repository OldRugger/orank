Rails.application.routes.draw do

  resources :meets
  resources :calc_runs

  get 'admin' => 'admin#index'
end
