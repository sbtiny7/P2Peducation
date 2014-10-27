Rails.application.routes.draw do

  namespace :accounts do
    resources :lessons
    resources :courses
  end
  get 'accounts/upload_avatar' => 'accounts/main#upload_avatar_page', as: :account_upload_avatar
  get 'accounts/courses/new/online'  => 'accounts/courses#new_online',  as: :new_accounts_courese_online
  get 'accounts/courses/new/offline' => 'accounts/courses#new_offline', as: :new_accounts_courese_offline
  get 'accounts/courses/edit/teacher' => 'accounts/courses#edit_teacher', as: :edit_accounts_courses_teacher
  put 'accounts/courses/teacher' => 'accounts/courses#update_teacher', as: :accounts_courses_teacher

  namespace :admin do
    resources :lessons
    resources :courses
    resources :users
  end

  get 'api/study/study.:format' => 'api/study#study'


  devise_for :users, path: "accounts",
  controllers: {
    sessions:      "accounts/sessions",
    registrations: "accounts/registrations",
    confirmations: "accounts/confirmations",
    passwords:     "accounts/passwords",
    unlocks:       "accounts/unlocks"
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
