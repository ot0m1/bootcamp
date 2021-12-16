# frozen_string_literal: true

class NotificationCallbacks
  def after_create(notification)
    return if !notification.mentioned? || notification.others_from_equal_path_to_equal_receiver_exists?(is_equal_kind: true, is_unread: true)

    Cache.delete_mentioned_and_unread_notification_count(notification.user.id)

    return if notification.others_from_equal_path_to_equal_receiver_exists?(is_equal_kind: true)

    Cache.delete_mentioned_notification_count(notification.user.id)
  end

  def after_update(notification)
    return if !notification.mentioned?\
      || !notification.saved_change_to_attribute?('read')\
      || notification.others_from_equal_path_to_equal_receiver_exists?(is_equal_kind: true, is_unread: true)

    Cache.delete_mentioned_and_unread_notification_count(notification.user.id)
  end

  def after_destroy(notification)
    return if !notification.mentioned? || notification.others_from_equal_path_to_equal_receiver_exists?(is_equal_kind: true, is_unread: true)

    Cache.delete_mentioned_and_unread_notification_count(notification.user.id) unless notification.read

    return if notification.others_from_equal_path_to_equal_receiver_exists?(is_equal_kind: true)

    Cache.delete_mentioned_notification_count(notification.user.id)
  end
end
