class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :authenticate_host_ownership, only: [:edit, :update]
  
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.hosted_events.build(event_params)

    if @event.save
      redirect_to @event
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
    @event.current_user = current_user
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    
    if @event.update(event_params)
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private 

  def event_params
    params.require(:event).permit([:name, :datetime_of, :location, :description])
  end

  def authenticate_host_ownership
    current_user.hosted_events.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "You do not have permission to #{action_name} this event!"
    redirect_to event_path
  end
end
