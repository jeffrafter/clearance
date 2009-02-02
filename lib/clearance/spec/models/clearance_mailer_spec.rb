module Clearance
  module Spec
    module Models
      module ClearanceMailerSpec
  
        def self.included(mailer_spec)
          mailer_spec.class_eval do
            
            describe "A change password email" do
              before do
                @user  = Factory(:user)
                @email = ClearanceMailer.create_change_password @user
              end

              it "should set its from address to DO_NOT_REPLY" do
                @email.from[0].should == DO_NOT_REPLY
              end

              it "should contain a link to edit the user's password" do
                host = ActionMailer::Base.default_url_options[:host]
                regexp = %r{http://#{host}/users/#{@user.id}/password/edit\?token=#{@user.token}}
                @email.body.should =~ regexp
              end

              it "should be sent to the user" do
                @email.to.should == [@user.email]
              end

              it "should set its subject" do
                @email.subject.should =~ /Change your password/
              end
            end
            
            describe "A confirmation email" do
              before do
                @user  = Factory(:user)
                @email = ClearanceMailer.create_confirmation @user
              end

              it "should set its recipient to the given user" do
                @email.to[0].should == @user.email
              end

              it "should set its subject" do
                @email.subject.should =~ /Account confirmation/
              end

              it "should set its from address to DO_NOT_REPLY" do
                @email.from[0].should == DO_NOT_REPLY
              end

              it "should contain a link to confirm the user's account" do
                host = ActionMailer::Base.default_url_options[:host]
                regexp = %r{http://#{host}/users/#{@user.id}/confirmation/new\?token=#{@user.token}}
                @email.body.should =~ regexp
              end
            end
          
          end
        end

      end
    end  
  end
end
