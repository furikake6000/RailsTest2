Rails.application.routes.draw do
  #トップページのパス
  root 'static_pages#home'

  #固定ページへのパス
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'

  #UserをRestfulなりソースに
  resources :users
end
