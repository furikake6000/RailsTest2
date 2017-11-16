Rails.application.routes.draw do
  #トップページのパス
  root 'static_pages#home'

  #固定ページへのパス
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'

  #ユーザ新規登録
  get 'signup' => 'users#new'

  #ログイン・ログアウト
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  #UserをRestfulなりソースに
  resources :users

  #AccountActivationはeditのみ可能
  resources :account_activations, only: [:edit]
end
