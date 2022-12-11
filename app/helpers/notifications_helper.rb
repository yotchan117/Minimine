module NotificationsHelper
  def unchecked_notifications
    @notifications = current_user.reverse_of_notifications.where(checked: false)
  end
end
