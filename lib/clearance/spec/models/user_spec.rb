module Clearance
  module Spec
    module Models
      module UserSpec
    
        def self.included(model_spec)
          model_spec.class_eval do
          
            # should_protect_attributes :email_confirmed, 
            #   :salt, :encrypted_password, 
            #   :token, :token_expires_at
            
            # signing up
            
            describe "When signing up" do
              # should_require_attributes        :email, :password
              # should_allow_values_for          :email, "foo@example.com"
              # should_not_allow_values_for      :email, "foo"
              # should_not_allow_values_for      :email, "example.com"
              # 
              # should_validate_confirmation_of  :password, 
              #   :factory => :user
              
              it "should initialize salt" do
                assert_not_nil Factory(:user).salt
              end
              
              it "should initialize token witout expiry date" do
                assert_not_nil Factory(:user).token
                assert_nil Factory(:user).token_expires_at
              end
              
              describe "encrypt password" do
                before do
                  @salt = "salt"
                  @user     = Factory.build(:user, :salt => @salt)
                  def @user.initialize_salt; end
                  @user.save!
                  @password = @user.password

                  @user.encrypt(@password)
                  @expected = Digest::SHA512.hexdigest("--#{@salt}--#{@password}--")
                end

                it "should create an encrypted password using SHA512 encryption" do
                  assert_equal     @expected, @user.encrypted_password
                  assert_not_equal @password, @user.encrypted_password
                end
              end
              
              it "should store email in lower case" do
                user = Factory(:user, :email => "John.Doe@example.com")
                assert_equal "john.doe@example.com", user.email
              end
            end
            
            describe "When multiple users have signed up" do
              before { @user = Factory(:user) }
              
              # should_require_unique_attributes :email
            end
            
            # confirming email
            
            describe "A user without email confirmation" do
              before do
                @user = Factory(:user)
                assert ! @user.email_confirmed?
              end

              describe "after #confirm_email!" do
                before do
                  assert @user.confirm_email!
                  @user.reload
                end

                it "should have confirmed their email" do
                  assert @user.email_confirmed?
                end
                
                it "should reset token" do
                  assert_nil @user.token
                end
              end
            end
            
            # authenticating
        
            describe "A user" do
              before do
                @user     = Factory(:user)
                @password = @user.password
              end
              
              it "should authenticate with good credentials" do
                assert User.authenticate(@user.email, @password)
                assert @user.authenticated?(@password)
              end
              
              it "should authenticate with good credentials, email in uppercase" do
                assert User.authenticate(@user.email.upcase, @password)
                assert @user.authenticated?(@password)
              end
              
              it "should not authenticate with bad credentials" do
                assert ! User.authenticate(@user.email, 'horribly_wrong_password')
                assert ! @user.authenticated?('horribly_wrong_password')
              end
            end

            # remember me
            
            describe "When authenticating with remember_me!" do
              before do
                @user = Factory(:email_confirmed_user)
                @token = @user.token
                assert_nil @user.token_expires_at
                @user.remember_me!
              end

              it "should set the remember token and expiration date" do
                assert_not_equal @token, @user.token
                assert_not_nil @user.token_expires_at
              end
              
              it "should remember user when token expires in the future" do
                @user.update_attribute :token_expires_at, 
                  2.weeks.from_now.utc
                assert @user.remember?
              end

              it "should not remember user when token has already expired" do
                @user.update_attribute :token_expires_at, 
                  2.weeks.ago.utc
                assert ! @user.remember?
              end
              
              it "should not remember user when token expiry date is not set" do
                @user.update_attribute :token_expires_at, nil
                assert ! @user.remember?
              end              
              
              # logging out
              
              describe "forget_me!" do
                before { @user.forget_me! }

                it "should unset the remember token and expiration date" do
                  assert_nil @user.token
                  assert_nil @user.token_expires_at
                end

                it "should not remember user" do
                  assert ! @user.remember?
                end
              end
            end
            
            # updating password
            
            describe "An email confirmed user" do
              before { @user = Factory(:email_confirmed_user) }

              describe "who changes and confirms password" do
                before do
                  @user.password              = "new_password"
                  @user.password_confirmation = "new_password"
                  @user.save
                end

                # should_change "@user.encrypted_password"
              end
            end
            
            # recovering forgotten password
            
            describe "An email confirmed user" do
              before do
                @user = Factory(:user)
                @user.confirm_email!
              end
              
              describe "who forgets password" do
                before do
                  assert_nil @user.token
                  @user.forgot_password!                  
                end
                it "should generate token" do
                  assert_not_nil @user.token
                end
                
                describe "and then updates password" do
                  describe 'with a valid new password and confirmation' do
                    before do
                      @user.update_password(
                        :password              => "new_password",
                        :password_confirmation => "new_password"
                      )
                    end
                    
                    # should_change "@user.encrypted_password"
                    it "should clear token" do
                      assert_nil @user.token
                    end                  
                  end
                  describe 'with a password without a confirmation' do
                    before do
                      @user.update_password(
                        :password              => "new_password",
                        :password_confirmation => ""
                      )                      
                    end                  
                    it "should not clear token" do
                      assert_not_nil @user.token
                    end                                      
                  end
                end                
              end
              
             
            end
          
          end
        end

      end
    end
  end
end
