require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  def setup

    @message = Message.new
    @message.name = 'Fred Bloggs'
    @message.email = 'test@test.co.uk'
    @message.message = 'balh blah'

  end

  test "join_acknowledge" do
    mail = Notifier.join_acknowledge
    assert_equal "Join acknowledge", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "join_notifier" do
    mail = Notifier.join_notifier
    assert_equal "Join notifier", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "contact_acknowledge" do
    mail = Notifier.contact_acknowledge(@message)
    assert_equal "Message from CK Casting", mail.subject
    assert_equal ["to@example.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match 'Fred Bloggs', mail.body.encoded
  end

  test "contact_notifier" do
    mail = Notifier.contact_notifier(@message)
    assert_equal "Contact nessage from CK Casting", mail.subject
    assert_equal ["to@example.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match 'Fred Bloggs', mail.body.encoded
  end

end
