platform :ios, '8.1'

inhibit_all_warnings!	

target 'Mattermost' do
  pod 'MagicalRecord'
  pod 'RestKit'
  pod 'BOString'
  pod 'IQKeyboardManager', :git => 'http://git.kilograpp.com/iOS/IQKeyboardManager.git'
  pod 'UIActivityIndicator-for-SDWebImage'
  pod 'ObjectiveSugar'
  pod 'DateTools'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'MFSideMenu', :git => 'http://git.kilograpp.com/iOS/MFSideMenu.git'
  pod 'SlackTextViewController'
  pod 'CTAssetsPickerController',  '~> 3.3.0'
  pod 'HexColors'
  pod 'JVFloatLabeledTextField'
  pod 'IDMPhotoBrowser'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] =     '$(inherited), PodsDummy_Pods=Uniqu  ePodsDummy_Pods'
        end
    end
end

