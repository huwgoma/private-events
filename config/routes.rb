Rails.application.routes.draw do
  devise_for :users
  
  devise_scope :user do 
    get "users", to: "devise/sessions#new"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "events#index"
  resources :users, only: :show
  
  resources :events do
    # Invites
    resources :invites, only: [:index, :create]
  end
  
  # Attendances
  get 'events/:id/attend', to: 'attendances#create', as: :attend
  delete 'events/:id/attend', to: 'attendances#destroy', as: :cancel_attend

  # Invites
  #get 'events/:event_id/invites', to: 'invites#index', as: :event_invites
end
