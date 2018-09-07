# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

platform :ios, '9.3'
inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/forcedotcom/SalesforceMobileSDK-iOS-Specs.git'
source 'https://git.ap.manulife.com/scm/rmf/podspecs.git'

def main
  pod 'SalesforceSDKCore', '~> 4.2.0'
  pod 'CryptoSwift', '0.7.0'
  pod 'ObjectMapper', '2.2.5'
  pod 'SAMKeychain', '1.5.3'
  pod 'ReachabilitySwift', '4.1.0'
end

target 'SecureStorage' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SecureStorage
  main

  target 'SecureStorageTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SecureStorageUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
