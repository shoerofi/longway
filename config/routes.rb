Rails.application.routes.draw do

  devise_for :users
  root "homes#index"

  resources :homes ,:reports ,:detailreports ,:lines ,:users ,:boards ,:problems

  get "data/" => "reports#data", :as => :data

end
