class ApplicationController < ActionController::Base
  before_action :configure_permitted_params, if: :devise_controller?
  around_action :convert_time_zone, if: :current_user

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :time_zone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :time_zone])
  end

  def convert_time_zone(&block)
    Time.use_zone("Eastern Time (US & Canada)", &block)
  end
end
