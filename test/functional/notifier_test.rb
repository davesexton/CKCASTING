require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  def setup

    @message = Message.new
    @message.name = 'Fred Bloggs'
    @message.email = 'test@test.co.uk'
    @message.message = 'balh blah'

    @applicant = applicants(:mail)

  end

  test "join_acknowledge" do
    mail = Notifier.join_acknowledge(@applicant)
    assert_equal "Join acknowledge", mail.subject
    assert_equal ["test@test.co.uk"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "join_notifier" do
    mail = Notifier.join_notifier(@applicant)
    assert_equal "CK Casting Application For New Applicant", mail.subject
    assert_equal ["to@example.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Application received", mail.body.encoded
  end

  test "contact_acknowledge" do
    mail = Notifier.contact_acknowledge(@message)
    assert_equal "Message from CK Casting", mail.subject
    assert_equal ["test@test.co.uk"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match 'Fred Bloggs', mail.body.encoded
  end

  test "contact_notifier" do
    mail = Notifier.contact_notifier(@message)
    assert_equal "CK Casting Contact Message From Fred Bloggs",
                 mail.subject
    assert_equal ["to@example.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match 'Fred Bloggs', mail.body.encoded
  end

end
