class NotificationItems::MotionEdited < NotificationItem
  attr_accessor :notification

  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(notification)
    @notification = notification
  end

  def actor
    @notification.event.user
  end

  def action_text
    I18n.t('notifications.motion_edited',
      edit_message: @notification.eventable.version_at(@notification.event.created_at).edit_message)
  end

  def title
    @notification.eventable.name
  end

  def link
    url_helpers.motion_path(@notification.eventable)
  end

  def avatar
    actor
  end
end
