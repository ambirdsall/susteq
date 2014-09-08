Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  root :to => "sessions#new"

  #ROUTES FOR PROVIDER DASHBOARD
  get '/employee', to: "employee/sessions#new", as: 'employee_signin'
  get '/employee/signout', to: 'employee/sessions#destroy', as: 'employee_signout' #get rather than delete bc of issue with twitter bootstrap link_to
  get '/dashboard', to:"dashboard#dashboard", as: "provider_dashboard"

  namespace :employee do
    resources :sessions, only: [:new, :create, :destroy]
  end

  resources :employees
  resources :pumps, only: [:index, :show]
  resources :kiosks, only: [:index, :show]

  #ROUTES FOR ADMIN DASHBOARD
  get '/admin', to: "admin/sessions#new", as: 'admin_signin'
  get '/admin/signout', to: 'admin/sessions#destroy', as: 'admin_signout' #get rather than delete bc of issue with twitter bootstrap link_to
  get '/admin/dashboard', to:'admin/admins#dashboard', as: 'admin_dashboard'
  get '/admin/my_profile', to: 'admin/admins#show_current', as: 'current_admin'
  get '/admin/edit_profile', to: 'admin/admins#edit_current', as: 'edit_current_admin'
  post '/admin/my_profile', to: 'admin/admins#update_current', as: 'update_current_admin' #post rather than put bc of issue with twitter bootstrap link_to

  namespace :admin do
    resources :sessions, only: [:new, :create, :destroy]
    get '/dashboard', to: 'admin/dashboard#index'
  end

  namespace :admin do
    resources :kiosks
    resources :pumps
    resources :hubs
    resources :providers do
      resources :hubs, :employees
    end
  end

end
