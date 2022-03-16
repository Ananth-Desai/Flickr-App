platform :ios, '11.0'

target 'Flickr' do
  pod 'libPhoneNumber-iOS', '~> 0.8', :modular_headers => true
  pod 'LeoUI', :git => 'https://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:x-oauth-basic@github.com/surya-soft/Leo-iOS-UI.git'
  pod 'Sedwig', :git => 'https://github.com/surya-soft/Sedwig.git'
  pod 'R.swift'
  target 'FlickrTests' do
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
