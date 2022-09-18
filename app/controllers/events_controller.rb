class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
  
  end

  def show

  end
end
