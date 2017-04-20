Rails.application.routes.draw do
  get 'meets/index'
  get 'meets/show'
  get 'meets/edit'
  get 'meets/new'
  post 'meets/new' => 'meets#create'

  get 'admin' => 'admin#index'
end
