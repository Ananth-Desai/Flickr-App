platform :ios, '11.0'

target 'Flickr-App' do
  pod 'libPhoneNumber-iOS', '~> 0.8', :modular_headers => true
  pod 'R.swift'
  target 'Flickr-AppTests' do
    pod 'libPhoneNumber-iOS', '~> 0.8', :modular_headers => true
  end

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
end
