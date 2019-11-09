platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!

def firebase_pods
  pod 'Fabric'
  pod 'Crashlytics'  
  pod 'Firebase/Analytics'
end

target 'Duiet' do
  pod 'LicensePlist'
  pod 'R.swift'
  firebase_pods

  target 'DuietTests' do
    inherit! :search_paths
    pod 'R.swift'
  end

  target 'DuietUITests' do
    inherit! :search_paths
    pod 'R.swift'
    firebase_pods
  end

end
