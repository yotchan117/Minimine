class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.reverse_of_notifications.page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
