Rails.application.routes.draw do
  
  devise_for :users
  root "pages#home"
  get 'm/manual',                       to: 'pages#manual'
  get '/t/new',                         to: 'pages#new_topic'
  get '/topics/create'
  get '/c/:category',                   to: 'pages#category'
  get '/t/:id',                         to: 'pages#topic'
  get '/posts/create'
  get '/makegame',                       to: 'pages#new_game'  
  
  
  
  
  
  

  get  '/help',                         to: 'example_pages#help'
  get  '/about',                        to: 'example_pages#about'
  get  '/admin',                        to: 'admin#manage'
  get  '/admin/create_user'
  get  '/admin/delete_user/:id',        to: 'admin#delete_user'
  get  '/admin/create_topic'
  get  '/admin/delete_topic/:id',       to: 'admin#delete_topic'
  get  '/admin/create_post'
  get  '/admin/delete_post/:id',        to: 'admin#delete_post'
  
  get  '/makegame',                     to: 'example_pages#makegame'
  get  '/signup',                       to: 'example_pages#signup'
  get  '/displayongoing',               to: 'example_pages#displayongoing'
  get  '/displayfinished',              to: 'example_pages#displayfinished'
  get  '/signup',                       to: 'example_pages#signup'
  get  '/discussion',                   to: 'example_pages#discussion'
  get  '/createaccount',                to: 'example_pages#createaccount'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
