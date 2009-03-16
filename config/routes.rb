ActionController::Routing::Routes.draw do |map|
  map.resource :contact_form, :only => [ :show, :create ]
end