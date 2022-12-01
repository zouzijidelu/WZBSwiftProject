source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/zouzijidelu/WZBSpec.git'
source 'https://gitlab.263nt.com/italkbbspecs/italkbbspecs'
source 'http://gitlab.italktv.com/c-common/Podspecs.git'

inhibit_all_warnings!
platform :ios, '9.0'
use_frameworks!

def shared_pods
    pod 'Kingfisher'
    pod 'Alamofire'
    pod 'CryptoSwift'
    pod 'SwiftyJSON'
    pod 'Aspects'
    pod 'OCModule'
    #pod 'iTPlayerManager', :git => 'http://gitlab.italktv.com/c-common/itplayermanager'
end

target 'WZBSwiftProject' do
  shared_pods
end
target 'WZBSwiftProjectBeta' do
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
