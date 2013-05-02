Ckcasting::Application.routes.draw do

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :families
  resources :applicants

  root :to => 'home#index'

  match 'castbook/castlist' => 'castbook#castlist'
  match 'castbook/(:id)' => 'castbook#index'
  match 'castbook/cast/(:id)' => 'castbook#show', as: :cast
  match 'home' => 'home#index'
  match 'join' => 'join#index'
  get 'backup' => 'admin#backup'
  get 'contact' => 'contact#index'
  post 'contact' => 'contact#send_message'

  get 'applicant' => 'applicant#index'
  #post 'applicant' => 'applicant#send_mail'

  match 'family_groups' => 'family_groups#index'
  match 'family_groups/family/(:id)' => 'family_groups#show'

  match 'admin' => 'admin#index'

  resources :applicants
  #resources :home

  resources :credits
  resources :uesrs

  resources :skills

  resources :people do
    member do
      post 'deactivate'
      post 'activate'
    end
  end

  resources :eye_colours

  resources :hair_colours

  get "home/index"


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
