source 'https://gitlab.263nt.com/italkbbspecs/italkbbspecs'
#source 'http://gitlab.italktv.com/c-common/Podspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
platform :ios, '9.0'
use_frameworks!

def shared_pods
    pod 'Kingfisher'
    pod 'Alamofire'
    pod 'CryptoSwift'
    pod 'SwiftyJSON'
#    pod 'MJRefresh', '3.2.0'
#    pod 'IQKeyboardManagerSwift', '5.0.0'
#    pod 'Cache'
#    pod 'GoogleAds-IMA-iOS-SDK'
#    pod 'iTAVideoAds'
#    pod 'google-cast-sdk-no-bluetooth'
#    pod 'Firebase/Core', '6.11.0'
#    pod 'Firebase/Messaging'
#    pod 'Fabric'
#    pod 'Crashlytics'
#    pod 'KeychainSwift'
#    pod 'GoogleTagManager'
    pod 'iMetisSDK', '0.4.9'
#    pod 'GoogleIDFASupport'
#    pod 'SnapKit'
#    pod 'FBSDKCoreKit/Swift'
#    pod 'FBSDKLoginKit/Swift'
#    pod 'FBSDKShareKit/Swift'
#    pod 'GoogleSignIn'

end

target 'WZBSwiftProject' do
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'IQKeyboardManagerSwift'
      print "Changing #{target.name} swift version to 4.1\n"
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.1'
      end
    end
  end
end
