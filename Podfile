# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HealthySecret' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HealthySecret

pod 'Alamofire', '5.1'
  
  pod 'SwiftyJSON'
end
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
    end
  end

