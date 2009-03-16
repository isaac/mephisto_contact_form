require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class ContactFormsController; def rescue_action(e) raise e end; end

class ContactNotifier
  def self.deliver_contact_notification(message, recipient)
    @last_message = message
  end
  
  def self.reset_last_message
    @last_message = nil
  end

  def self.last_message
    @last_message
  end
end


class ContactFormsControllerTest < ActiveSupport::TestCase
  fixtures :contents, :content_versions, :sections, :assigned_sections, :sites, :users, :tags, :taggings

  def setup
    prepare_theme_fixtures
    FileUtils.cp_r File.dirname(__FILE__) + '/contact_us.liquid', File.join(THEME_ROOT, 'site-1', 'current', 'templates')

    @controller = ContactFormsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_contact_form
    get :show
    assert_response :success
    check_contact_form
  end

  def check_contact_form
    assert_select "h1", "Contact Us"
    assert_select "input[type=text][id=contact_author]"
    assert_select "input[type=text][id=contact_author_email]"
    assert_select "input[type=text][id=contact_author_phone]"
    assert_select "input[type=text][id=contact_subject]"
    assert_select "textarea[id=contact_body]"
    assert_select "input[type=submit][value=Send]"
  end

  def test_contact_submit_with_validation_errors
    post :create
    assert_response :success
    check_contact_form
    assert_select "ul[id=contact-errors]"
    assert_select "li", "Body can't be blank"
    assert_select "li", "Author can't be blank"
    assert_select "li", "Subject can't be blank"
    assert_select "li", "Author email can't be blank"
    assert_select 'form[method=post][id=contact-form][action="/contact_form"]'
  end

  def test_contact_submit_with_valid_data
    ContactNotifier.reset_last_message

    post :create, {
      'contact' => {
        'author' => 'James Crisp',
        'author_email' => 'james@crispdesign.net',
        'author_phone' => '12345',
        'subject' => 'Hey mate!',
        'body' => 'Great site!' }}
    assert_response :success
    assert_select 'p[id=contact-message]', 'Thank you for your feedback.'
    
    assert_not_nil ContactNotifier.last_message
    assert_equal 'James Crisp', ContactNotifier.last_message.author
    assert_equal 'james@crispdesign.net', ContactNotifier.last_message.author_email
    assert_equal '12345', ContactNotifier.last_message.author_phone
    assert_equal 'Hey mate!', ContactNotifier.last_message.subject
    assert_equal 'Great site!', ContactNotifier.last_message.body

    ContactNotifier.reset_last_message
  end

end
