require 'clearance/app/controllers/application_controller'
require 'clearance/app/controllers/confirmations_controller'
require 'clearance/app/controllers/passwords_controller'
require 'clearance/app/controllers/sessions_controller'
require 'clearance/app/controllers/users_controller'
require 'clearance/app/models/clearance_mailer'
require 'clearance/app/models/user'

if defined? Spec
  require 'clearance/spec'
else
  require 'clearance/test'
end
