Rails.application.routes.draw do

  mount_ember_app :frontend, to: "/frontend"  # mounting ember app

  resources :dictionaries

  # user routes
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}
  resources :users do
    member do
      get 'edit_your_dictionaries'
      post 'update_your_dictionaries'
    end
    collection do
      get 'backup_restore_form'
      post 'backup_restore'
    end
  end
  resources :admins, controller: 'users' do
    collection do
      get 'words'
      get 'backup_restore_for_all_users_form'
      post 'backup_restore_for_all_users'
    end
  end
  resources :generals, controller: 'users'

  # normal routes for AppSetting, Word, and Flag
  resources :app_settings
  resources :words do
    member do
      get 'ajax_promote_flag'
    end
    collection do
      # get 'expire_my_word_caches'
      get 'my_statistics'
    end
  end
  resources :flags

  # routes for SiteHome controller
  get 'site_home/home'
  get 'site_home/sign_up'
  get 'site_home/sign_in'
  get 'site_home/contact_us'
  get 'site_home/about_us'
  get 'site_home/faqs'
  get 'site_home/help'
  match 'error' => 'site_home#display_error', :as => 'display_error', :via => [:get, :post]

  # Nested Routes
  resources :flags do
    resources :words, :only => [:index]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'site_home#home'

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
