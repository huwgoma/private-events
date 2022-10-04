class ApplicationController < ActionController::Base
  before_action :configure_permitted_params, if: :devise_controller?
  around_action :convert_time_zone, if: :current_user

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :time_zone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :time_zone])
  end

  def convert_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def authenticate_event_host(event_id)
    current_user.hosted_events.find(event_id)
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "You do not have permission to #{action_name} this event!"
    redirect_to event_path(event_id)
  end
end
