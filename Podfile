source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
platform :ios, '10.0'

plugin 'cocoapods-keys', {
    :project => "TaskFor500px",
    :keys => [
        "APIKey",
    ]
}

target 'TaskFor500px' do
    pod 'Then', '2.6.0'
    pod 'RxSwift' , '5.0.0'
    pod 'RxCocoa', '5.0.0'
    pod 'SnapKit', :git => 'https://github.com/Noobish1/SnapKit.git', :branch => 'feature/superview-or-safearealayoutguide'
    pod 'Moya/RxSwift', '14.0.0-beta.2'
    pod 'KeyedAPIParameters', '1.1.0'
    pod 'R.swift', '5.0.3'
    pod 'Kingfisher', '5.9.0'
    pod 'UIScrollView-InfiniteScroll', '1.1.0'
    
    # Debug pods
    pod 'SwiftLint', '0.35.0', :configurations => ['Debug']
    pod 'Reveal-SDK', '24', :configurations => ['Debug']
end

post_install do | installer |
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
