class ClearanceFeaturesGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory File.join("features", "step_definitions")
      
      ["features/step_definitions/clearance_steps.rb",
       "features/sign_in.feature",
       "features/password_reset.feature",
       "features/sign_out.feature",       
       "features/sign_up.feature"].each do |file|
        m.file file, file
       end
    end
  end
  
end
