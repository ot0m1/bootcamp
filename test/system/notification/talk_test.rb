# frozen_string_literal: true

require 'application_system_test_case'

class Notification::AnswersTest < ApplicationSystemTestCase
  test '誰かが相談部屋でコメントをした際にadminは通知を受け取る' do
    talk_id = users(:kimura).talk.id
    visit_with_auth "/talks/#{talk_id}", 'kimura'
    within('.thread-comment-form__form') do
      fill_in('new_comment[description]', with: 'test')
    end
    page.all('.a-form-tabs__tab.js-tabs__tab')[1].click
    assert_text 'test'
    click_button 'コメントする'
    wait_for_vuejs
    assert_text 'test'

    logout
    login_user 'machida', 'testtest'

    open_notification
    assert_equal 'kimuraさんが相談部屋でコメントをしました。'
                 notification_message
  end

  test '自分以外の誰かが自分の相談部屋でコメントをした際に通知を受け取る' do
    talk_id = users(:kimura).talk.id
    visit_with_auth "/talks/#{talk_id}", 'komagata'
    within('.thread-comment-form__form') do
      fill_in('new_comment[description]', with: 'test')
    end
    page.all('.a-form-tabs__tab.js-tabs__tab')[1].click
    assert_text 'test'
    click_button 'コメントする'
    wait_for_vuejs
    assert_text 'test'

    logout
    login_user 'kimura', 'testtest'

    open_notification
    assert_equal 'komagataさんから相談部屋でコメントが届きました。'
                 notification_message
  end
end