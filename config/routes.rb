Rails.application.routes.draw do
  resources :admin_time_slots, except: [:show]
  resources :admin_tables, except: [:show]
  resources :admin_reservations, only: [:index, :show, :edit, :update] do
    member do
      patch :cancel
    end
  end
  get "admin/calendar", to: "admin_calendar#index", as: :admin_calendar
  root "pages#home"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "register", to: "registrations#new"
  post "register", to: "registrations#create"

  # Reservations
  get "availability", to: "reservations#availability"
  get "my-reservations", to: "reservations#index", as: :my_reservations
  resources :reservations, only: [:new, :create, :show] do
    member do
      patch :cancel
    end
  end

  get "admin", to: "admin#dashboard", as: :admin_dashboard

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
