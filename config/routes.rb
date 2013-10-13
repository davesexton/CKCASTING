Ckcasting::Application.routes.draw do

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :families
  resources :applicants
  resources :skills
  resources :credits
  resources :applicants
  resources :eye_colours
  resources :hair_colours
  resources :people do
    member do
      post 'deactivate'
      post 'activate'
    end
  end

  get 'castbook/castlist' => 'castbook#castlist'
  get 'castbook' => 'castbook#index'
  get 'castbook/cast/(:id)' => 'castbook#show', as: :cast
  get 'join' => 'join#index'
  get 'backup' => 'admin#backup'
  get 'header' => 'admin#header'
  post 'header' => 'admin#update'
  get 'contact' => 'contact#index'
  post 'contact' => 'contact#send_message'

  get 'applicant' => 'applicant#index'
  get 'admin' => 'admin#index'

  get 'family_groups' => 'family_groups#index'
  get 'family_groups/family/(:id)' => 'family_groups#show', as: :family_groups_family

  root :to => 'home#index'

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
  # match ':controller(/:action(/:id(.:format)))'
end
