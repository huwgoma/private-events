Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users
  
  devise_scope :user do 
    get "users", to: "devise/sessions#new"
  end
  
  # Defines the root path route ("/")
  root "events#index"

  # Users
  resources :users, only: :show
  
  # Events
  resources :events do
    #Invites - Inviters
    resources :invites, only: :create do
      collection do
        get '', to: 'invites#manage' # GET events/:event_id/invites
        delete '', to: 'invites#revoke' # DELETE events/:event_id/invites
      end
    end

    # Attendances
    resources :attendances, only: :create do
      delete '', to: 'attendances#destroy', on: :collection # DELETE events/:event_id/attendances
    end
  end

  # Invites - Invitees
  resources :invites, only: :index do
    member do
      post 'accept' # POST invites/:id/accept
      post 'decline' # POST invites/:id/decline
    end
  end
end
