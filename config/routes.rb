Rails.application.routes.draw do
  
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  # 出勤画面表示・編集
  get  '/attendance_display', to: 'attendance#attendance_display'
  post '/attendance_display', to: 'attendance#attendance_display'
  patch '/attendance_display', to: 'attendance#attendance_display'
  get  '/attendance_edit', to: 'attendance#attendance_edit'
  post '/attendance_edit', to: 'attendance#attendance_edit'
  patch '/attendance_edit', to: 'attendance#attendance_edit'

  # 基本情報
  
  get '/basic_info',   to: 'users#update_basic_info'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :attendance
  resources :users do
    member do
      #  /users/:id...
      get :following, :followers
      # GET /users/1/following => following_action
      # GET /users/1/followers => followers_action
    end
  end
  resources :account_activations, only: [:edit]
  # GET "/acctount_activations/:id/edit"
  #params[:id]  <== 有効化トークン
  #Controller: params[:id]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts,      only: [:create, :destroy] 
  resources :relationships,   only: [:create, :destroy]
  
end


