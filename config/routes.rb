Rails.application.routes.draw do

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
    root 'accounts/main#index'
    get 'upload_avatar' => 'accounts/main#upload_avatar_page', as: :account_upload_avatar
    resources :courses do
      resources :lessons
      member do
        get 'teacher', as: :accounts_course_teacher
        match 'teacher_action', as: :accounts_course_teacher_action, via: [:put, :post, :patch]
        get 'teacher/:teacher_id/complate' => 'accounts/courses#complate', as: :complate_accounts_course
        get 'pub' => 'accounts/courses#pub', as: :pub_accounts_course
      end
      collection do
        get 'new/online'  => 'accounts/courses#new_online',  as: :new_accounts_course_online
        get 'new/offline' => 'accounts/courses#new_offline', as: :new_accounts_course_offline
      end
    end
  end

  # ↑ 用户使用的管理页面 ↑



  # ↓ 基于DEVISE的用户账号管理 ↓

  devise_for :users, path: "accounts",
  controllers: {
    sessions:      "accounts/sessions",
    registrations: "accounts/registrations",
    confirmations: "accounts/confirmations",
    passwords:     "accounts/passwords",
    unlocks:       "accounts/unlocks"
  }

  # ↑ 基于DEVISE的用户账号管理 ↑



  # ↓ 主页、课程展示等，未登录用户也能观看的部分 ↓

  get 'course/:course_id' => 'home#course', as: :course

  root 'home#index'

  # ↑ 主页、课程展示等，未登录用户也能观看的部分 ↑



  # ↓ 其他（如有优先级需求可以上移） ↓

  mount ChinaCity::Engine => '/china_city' # 选择地址插件所用

  # ↑ 其他（如有优先级需求可以上移） ↑
end
