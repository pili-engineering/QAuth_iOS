# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'QAuth_iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for QAuth_iOS

  pod 'Masonry', '~> 1.1.0'
  pod 'CocoaSecurity'

  pod 'AFNetworking', '~> 4.0.1'
  pod 'SVProgressHUD'
  pod 'ChameleonFramework'
  pod 'lottie-ios', '~> 2.5.3'
  pod 'YYModel'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
