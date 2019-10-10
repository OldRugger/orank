Rails.application.routes.draw do

  get 'split_course/index'

  get 'split_course/show'

  get 'split_course/show_runner'

  get 'split_course/show_runner_all'

  get 'power_ranking/show'

  get 'runners/show'
  
  get 'runners' => 'runners#index'

  resources :meets
  resources :calc_runs

  get 'admin' => 'admin#index'
  
  get 'calc_runs_show_all' => 'calc_runs#show_all'
  
  get 'power_rankings' => 'power_rankings#show'
  
  root :to => "calc_runs#index"
  
  post 'badges' => 'badges#create'

  post 'calc_runs/publish' => 'calc_runs#publish'
  post 'calc_runs/unpublish' => 'calc_runs#unpublish'

  post 'news/publish' => 'news#publish'
  post 'news/unpublish' => 'news#unpublish'

end
