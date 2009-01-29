require File.join(File.dirname(__FILE__), 'test_helper')

class ClearanceGeneratorTest < GeneratorTestCase
  def test_correctly_generates_files
    run_generator('clearance', [])
    
    assert_generated_model_for :user
    assert_generated_unit_test_for :user    
    
    assert_generated_model_for :clearance_mailer, 'ActionMailer::Base'
    assert_generated_unit_test_for :clearance_mailer, 'ActionMailer::TestCase'
    
    assert_generated_file 'app/controllers/application.rb' do |body|
      assert_match 'include Clearance::App::Controllers::ApplicationController', 
        body
    end
    
    %w(users sessions confirmations passwords).each do |controller|
      assert_generated_controller_for controller
      assert_generated_functional_test_for controller
    end
    
    assert_generated_views_for :users, 'new.html.erb', 'edit.html.erb'
    assert_generated_views_for :sessions, 'new.html.erb'
    assert_generated_views_for :passwords, 'new.html.erb', 'edit.html.erb'
    
    assert_generated_file 'test/factories/clearance.rb'
    
    assert_generated_migration 'create_or_update_users_with_clearance_columns'
    
    assert_added_route_for :users
    assert_added_route_for :passwords
    #assert_added_route_for :session
    #assert_added_route_for :users, :has_one => [:password, :confirmation]
  end
end
