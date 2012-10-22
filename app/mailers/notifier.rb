class Notifier < ActionMailer::Base
  default from: APP_CONFIG['email_from']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.join_acknowledge.subject
  #
  def join_acknowledge(applicant)
    @greeting = "Hi"
    @applicant = applicant
    mail to: applicant.email_address
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.join_notifier.subject
  #
  def join_notifier(applicant)
    @greeting = "Hi"
    @applicant = applicant
    mail subject: "CK Casting Application For #{applicant.first_name} #{applicant.last_name}",
         to: APP_CONFIG['email_to']
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.contact_acknowledge.subject
  #
  def contact_acknowledge(message)
    @greeting = "Hi"
    @message = message
    mail subject: 'Message from CK Casting',
         to: message.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.contact_notifier.subject
  #
  def contact_notifier(message)
    @greeting = "Hi"
    @message = message
    mail subject: "CK Casting Contact Message From #{message.name}",
         to: APP_CONFIG['email_to']
  end
end
