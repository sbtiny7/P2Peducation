Rails.application.routes.draw do


  scope path: '/public' do
    get 'courses/:id' => 'courses#show', :as => 'public_show_course'
    get 'enroll' => 'courses#enroll', :as => 'public_enroll_course'
    post 'enroll' => 'courses#enroll_create', :as => 'enroll_course'
  end


  # ↓ 网页端API ↓

  namespace :api do
    post 'upload_video(.:format)' => 'server#upload_video'
  end

  # ↑ 网页端API ↑


  # ↓ 移动端API ↓

  get 'api/study/study.:format' => 'api/study#study'

  # ↑ 移动端API ↑


  # ↓ 咱们用的后台管理 ↓

  namespace :admin do
    resources :lessons
    resources :courses
    resources :users
    resources :agreements
  end

  # ↑ 咱们用的后台管理 ↑


  # ↓ 用户使用的管理页面 ↓

  namespace :accounts do
    get "student/learning"  => "dashboard#learning", :as => :learning
    get "student/pending"  => "dashboard#pending" 
    get "student/favorite"  => "dashboard#favorite"
    get "incoming"  => "dashboard#incoming", :as => :incoming
    get "teach"  => "dashboard#teach"
    root 'main#index'
    get 'config' => 'main#config_account', as: :config
    patch 'update' => 'main#update_account', as: :update
    get   'config_avatar' => 'main#config_avatar', as: :config_avatar
    match 'upload_avatar' => 'main#upload_avatar', as: :upload_avatar, via: [:post, :patch]
    match 'upload_avatar' => 'main#delete_avatar', as: :delete_avatar, via: [:delete]
    resources :courses do
      resources :lessons do
        resources :videos
      end
      resources :videos
      member do
        get 'teacher'
        match 'teacher_action', via: [:put, :post, :patch]
        get 'teacher/:teacher_id/complate' => 'courses#complate', as: :complate
        get 'pub'
      end
      collection do
        get 'new/online' => 'courses#new_online'
        get 'new/offline' => 'courses#new_offline'
      end
    end

    resources :orders, :only => [:index, :show, :new, :create] do
      collection do
        get :successful
        post :alipay_notify
        post :check_quantity
      end
    end
  end

  # ↑ 用户使用的管理页面 ↑


  # ↓ 基于DEVISE的用户账号管理 ↓

  devise_for :users, path: "accounts",
  controllers: {
    sessions: "accounts/sessions",
    registrations: "accounts/registrations",
    confirmations: "accounts/confirmations",
    passwords: "accounts/passwords",
    unlocks: "accounts/unlocks"
  }

  # ↑ 基于DEVISE的用户账号管理 ↑


  # ↓ 主页、课程展示等，未登录用户也能观看的部分 ↓

  get 'course/:id' => 'courses#show_after_bought', as: :course
  get 'courses' => 'courses#index', as: :courses

  root 'home#index'
  get '/live_class/1'

  # ↑ 主页、课程展示等，未登录用户也能观看的部分 ↑


  # ↓ 其他（如有优先级需求可以上移） ↓

  #mount ChinaCity::Engine => '/china_city' # 选择地址插件所用

  # ↑ 其他（如有优先级需求可以上移） ↑

end
