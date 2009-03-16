class ContactNotifier < ActionMailer::Base
  include Mephisto::Liquid::UrlMethods
    
  def contact_notification(contact_message, recipient)
    recipients      recipient
    from            contact_message.author_email
    subject         "[Mephisto Contact Form] #{contact_message.subject}"
    body            "contact_message" => contact_message
  end
end

