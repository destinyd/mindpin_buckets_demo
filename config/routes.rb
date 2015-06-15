Rails.application.routes.draw do
  #get '/buckets' => 'mindpin_buckets/buckets#index'
  #post '/buckets' => 'mindpin_buckets/buckets#create'
  #post '/bucketings' => 'mindpin_buckets/bucketings#create'
  #delete '/bucketings' => 'mindpin_buckets/bucketings#destroy'
  mount MindpinBuckets::Engine => '/', :as => 'aaa'
  resources :folders
  resources :photos
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  root 'home#index'
end
