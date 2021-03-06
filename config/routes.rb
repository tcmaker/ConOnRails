ConOnRails::Application.routes.draw do
  root controller: :events, action: :index, active: true

  match '/public', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'
  match '/sessions/getroles', to: 'sessions#getroles'
  match '/lost_and_found', to: 'lost_and_found#index'
  match '/admin', to: 'admin#index'
  match '/banner', to: 'application#banner'

  resources :admin, only: [:index]
  resources :audits, only: [:index]
  resources :contacts, except: [:destroy]
  resources :conventions, except: [:destroy]
  resources :departments

  resources :duty_board, only: [:index] do
    member do
      get :assign_slot
    end
  end

  resources :duty_board_groups, except: [:show]

  resources :duty_board_slots do
    member do
      post :clear_assignment
    end
  end

  resources :events, except: [:destroy] do
    collection do
      get 'review'
      get 'sticky'
      get 'secure'
      post 'merge_events'
      post 'search_entries'
    end
  end

  resources :login_log, only: [:index]
  resources :lost_and_found, only: [:index]
  resources :lost_and_found_items, except: [:destroy] do
    collection do
      get 'searchform'
    end
  end
  resources :messages


  resources :radio_admin, only: [:index]
  resources :radio_assignments, only: [:create, :update, :destroy]
  resources :radio_assignment_audits, only: [:index]
  resources :radio_groups do
    collection do
      get 'delindex'
    end
  end
  resources :radios do
    member do
      get 'checkout'
      get 'select_department'
      # put 'create_assignment'
    end
    collection do
      post 'search_volunteers' #This is cheating
    end
  end

  resources :roles
  resources :sessions, only: [:new, :create, :destroy]
  resources :users do
    member do
      get :change_password
    end
  end

  resources :volunteers do
    post 'new_from_attendee'
    member do
      post 'associate'
      post 'new_user'
    end
    collection do
      get 'attendees'
      get 'clear_all_radio_training'
    end
  end

  resources :vsps, except: [:show, :destroy]

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
