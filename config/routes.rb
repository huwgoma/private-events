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
  resources :events 

  # Invites Refactor
  resources :invites, only: :index do
    member do
      post 'accept' # POST invites/:id/accept
      post 'decline' # POST invites/:id/decline
    end
  end

  # Manage Invites - Inviter/Invitee
  get 'events/:event_id/invites', to: 'invites#inviter_index', as: :event_invites
  #get 'users/:user_id/invites', to: 'invites#invitee_index', as: :user_invites
  # Create/Revoke Invites
  post 'events/:event_id/invites', to: 'invites#create'
  delete 'events/:event_id/invites', to: 'invites#revoke'
  # Accept/Decline Invite
  #post 'users/:user_id/invites/:id/accept', to: 'invites#accept', as: :accept_invite
  #post 'users/:user_id/invites/decline', to: 'invites#decline', as: :decline_invite
  
  # Attendances
  get 'events/:id/attend', to: 'attendances#create', as: :attend
  delete 'events/:id/attend', to: 'attendances#destroy', as: :cancel_attend
end
