Rails.application.routes.draw do

  scope path: '/public' do
    get 'courses/:id' => 'courses#show', :as => 'public_show_course'
    get 'enroll' => 'courses#enroll', :as => 'public_enroll_course'
    post 'enroll' => 'courses#enroll_create', :as => 'enroll_course'
  end

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
    get "student/learning"  => "dashboard#learning" 
    get "student/pending"  => "dashboard#pending" 
    get "student/favorite"  => "dashboard#favorite"
    get "incoming"  => "dashboard#incoming"
    get "teach"  => "dashboard#teach"
    root 'main#index'
    get 'config' => 'main#config_account', as: :config
    patch 'update' => 'main#update_account', as: :update
    get   'config_avatar' => 'main#config_avatar', as: :config_avatar
    match 'upload_avatar' => 'main#upload_avatar', as: :upload_avatar, via: [:post, :patch]
    post 'delete_avatar' => 'main#delete_avatar', as: :delete_avatar

    get 'courses/:id/publish' => 'courses#publish_course', as: :publish_course
    get 'cosrses/:id/cancel_publish' => 'courses#cancel_publish_course', as: :cancel_publish_course

    resources :courses do
      resources :lessons
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

  get 'course/:course_id' => 'course#show', as: :course
  get 'courses' => 'course#index', as: :courses
  get 'courses/:id/mark' => 'courses#mark_course', as: :mark_course

  root 'home#index'
  get '/live_class/1'

  # ↑ 主页、课程展示等，未登录用户也能观看的部分 ↑


  # ↓ 其他（如有优先级需求可以上移） ↓

  #mount ChinaCity::Engine => '/china_city' # 选择地址插件所用

  # ↑ 其他（如有优先级需求可以上移） ↑

end
