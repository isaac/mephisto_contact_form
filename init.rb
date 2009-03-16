Liquid::Template.register_tag(:contactform, Mephisto::Liquid::ContactForm)

module ::Mephisto
  module Plugins
    class ContactForm < Mephisto::Plugin
      
      author 'James Crisp'
      notes 'Plugin for Mephisto which provides a customisable contact us / feedback form. Feedback / messages are sent via email to an address you specify.'
      homepage 'http://jamescrisp.org/2007/03/19/contact-feedback-form-plugin-for-mephisto/'
      
      option :email, nil
      
    end
  end
end