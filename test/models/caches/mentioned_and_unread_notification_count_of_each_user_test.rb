# frozen_string_literal: true

require 'test_helper'

class MentionedAndUnreadNotificationCountOfEachUserTest < ActiveSupport::TestCase
  test 'increase the cached value of unread mentions by 1 after create a mention' do
    receiver = users(:kimura)

    assert_difference -> { Cache.mentioned_and_unread_notification_count(receiver) }, 1 do
      Notification.mentioned(Comment.first, receiver) # TODO: 既存の通知元パス以外のパスにあるコメントを使って通知を追加しないと、テストが落ちることがある
    end
  end

  test 'decrease the cached value of unread mentions by 1 after delete a unread mention' do
    receiver = users(:kimura)

    assert_difference -> { Cache.mentioned_and_unread_notification_count(receiver) }, -1 do
      receiver.notifications.unreads.first.destroy! # TODO: 未読通知を削除しても通知元パスの種類が減らない時はテストが落ちる
    end
  end
end
