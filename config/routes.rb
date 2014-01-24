# 个人页
Education::Application.routes.draw do
  resources :users, :shallow => true do
    collection do
      get :me
      get :content_search
    end
  end
end

# 短消息
Education::Application.routes.draw do
  resources :short_messages, :shallow => true do
    collection do
      get :chatlog
    end
  end
end

# 记录用户数据
Education::Application.routes.draw do
  resources :collect_users, :shallow => true do
    collection do
      get :user_attrs
    end

    member do
      get :user_des
    end
  end
end


Education::Application.routes.draw do
  devise_for :users,:path => 'account',
                    :controllers => {  
                      :registrations => :account,  
                      :sessions => :sessions  
                    } 

  devise_scope :user do 
    get '/two_in/sign_in' => 'sessions#new_two'
    get '/education/sign_in' => 'sessions#new_education'
  end
                    
  root :to => 'index#index'
  get '/user_home'  => 'index#user_home'
  get '/admin_home' => 'index#admin_home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
