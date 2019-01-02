Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  # 出勤画面表示・編集
  get  '/attendance_update', to: 'attendance#attendance_update'
  post '/attendance_update', to: 'attendance#attendance_update'
  patch '/attendance_update', to: 'attendance#attendance_update'
  
  get  '/attendance_edit', to: 'attendance#attendance_edit'
  post '/attendance_edit', to: 'attendance#attendance_edit'
  patch '/attendance_edit', to: 'attendance#attendance_edit'

  get  '/update_all', to: 'attendance#update_all'
  post '/update_all', to: 'attendance#update_all'
  patch '/update_all', to: 'attendance#update_all'

  # 基本情報
  get '/basic_info',   to: 'users#edit_basic_info'
  patch '/basic_info',   to: 'users#update_basic_info'
  
  resources :users do
    collection { post :import }
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
  #resource  :attendances
  
  # 拠点情報
  resources :base_points
  post '/base_point/create',  to: 'base_points#create', as: 'base_point_create'
  
  # CSV
  get '/attendance_table', to: 'users#attendance_table', as: 'attendance_table'
  
  # 残業申請関係
  post '/attendance/oneday_overtime', to: 'attendance#oneday_overtime', as: 'oneday_overtime'
  
  # 出勤中社員一覧
  get '/attendance_employees', to: 'users#attendance_index', as: 'attendance_index'
  
  
end


