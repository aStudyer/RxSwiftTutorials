# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'RxSwiftDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RxSwiftDemo
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'MJExtension'
    pod 'R.swift'
    pod 'ObjectMapper'
    pod 'Alamofire'
    pod 'RxAlamofire'
    pod 'Moya/RxSwift'
    pod 'Result'
    pod 'HHUIBase_Swift', :git => 'https://github.com/aStudyer/HHUIBase_Swift.git'
    pod 'Moya-ObjectMapper/RxSwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end
