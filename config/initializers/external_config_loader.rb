standard_config_location = Rails.root.join('..').join('local_myaka_config.rb')
if standard_config_location.exist?
  require standard_config_location
end
if ENV['MYAKA_CONFIG']
  require Rails.root.join(ENV['MYAKA_CONFIG'])
end
