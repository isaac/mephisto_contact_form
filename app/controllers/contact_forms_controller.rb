class ContactFormsController < ApplicationController

  def show
    render_liquid_template_for(:contact_us, :status => "200 OK")
  end

  def create
    message = ContactMessage.new(params[:contact])
    if (message.valid?)
      recipient = Mephisto::Plugin[:contact_form].email || site.email || site.admins.first.email
      ContactNotifier.deliver_contact_notification(message, recipient)
      render_liquid_template_for(:contact_us, 'message' => "Thank you for your feedback.", :status => "200 OK")
    else
      render_liquid_template_for(:contact_us, 'errors' => message.errors.full_messages, 
        'submitted' => params[:contact], :status => "200 OK")
    end
  end
end
