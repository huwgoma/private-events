Rails.application.routes.draw do
  devise_for :users
  
  devise_scope :user do 
    get "users", to: "devise/sessions#new"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

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
  end

  # Invites - Invitees
  resources :invites, only: :index do
    member do
      post 'accept' # POST invites/:id/accept
      post 'decline' # POST invites/:id/decline
    end
  end
  
  # Attendances
  get 'events/:id/attend', to: 'attendances#create', as: :attend
  delete 'events/:id/attend', to: 'attendances#destroy', as: :cancel_attend
end
