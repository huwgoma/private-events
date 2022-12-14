class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action -> { authenticate_event_host(params[:id]) }, only: [:edit, :update, :destroy]
  
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
    @invite = @event.invites.find_by(invitee: current_user) 
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

  def destroy
    Event.find(params[:id]).destroy
    flash[:notice] = "Event successfully deleted."
    redirect_to root_path
  end

  private 

  def event_params
    params.require(:event).permit([:name, :datetime_of, :location, :is_private, :description])
  end
end
