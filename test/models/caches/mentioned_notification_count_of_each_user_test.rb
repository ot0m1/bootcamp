# frozen_string_literal: true

require 'test_helper'

class MentionedNotificationCountOfEachUserTest < ActiveSupport::TestCase
  test 'increase the cached value of mentioned notification count by 1 after create a mentioned one from new source path' do
    receiver = users(:kimura)
    existing_source_pathes = receiver.notifications.by_target(:mention).map { |notification| notification.read_attribute :path }.uniq
    comment_in_new_source_path = Comment.find { |comment| !comment.path.in?(existing_source_pathes) }

    assert_difference -> { Cache.mentioned_notification_count(receiver) }, 1 do
      Notification.mentioned(comment_in_new_source_path, receiver)
    end
  end

  # このケースはキャッシュが削除されないのでテストが不要（もし assert_no_difference のブロックに渡した処理でキャッシュ対象の値が増減しようとも、キャッシュが削除されないなら必ず assert_no_difference が true になるため
  # ただし、現状は test モードではキャッシュが有効になっておらず、その上 assert_no_difference のブロックに渡した処理でキャッシュ対象の値が増えているので、このテストは落ちている
  test "don't increase the cached value of mentioned notification count by 1 after create a mentioned one from existing source path" do
    receiver = users(:kimura)
    existing_source_pathes = receiver.notifications.by_target(:mention).map { |notification| notification.read_attribute :path }.uniq
    comment_in_existing_source_path = Comment.find { |comment| comment.path.in?(existing_source_pathes) }

    assert_no_difference -> { Cache.mentioned_notification_count(receiver) } do
      Notification.mentioned(comment_in_existing_source_path, receiver) # TODO: フィクスチャのデータの作成日時が同じであるため最新ではない通知もカウント対象に含まれてしまってテストが落ちる。クエリの修正待ち。
    end
  end

  # ↑と同じ理由で、このテストは不要となる
  # test "don't decrease the cached value of mentioned notification count by 1 after delete 通知元パスが他と重複するメンション"

  # test "decrease the cached value of mentioned notification count by 1 after delete 通知元パスが他と重複しないメンション"
end
