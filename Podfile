# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'myTube' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for myTube
pod 'Alamofire'
pod 'SDWebImage'
pod 'SwiftyJSON'
pod 'CarbonKit'
pod 'ChameleonFramework'
pod 'ObjectMapper'
pod 'AlamofireObjectMapper', '~> 4.0'
pod 'Google/SignIn'
pod 'CMTabbarView'
pod 'NVActivityIndicatorView'
pod 'MXParallaxHeader'
pod 'VGPlayer'
pod 'SGActionView'
pod 'XCDYouTubeKit'
pod 'PickerView'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
        end
    end
end
