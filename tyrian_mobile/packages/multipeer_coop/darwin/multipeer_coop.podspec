Pod::Spec.new do |s|
  s.name             = 'multipeer_coop'
  s.version          = '0.1.0'
  s.summary          = 'Multipeer Connectivity transport for Kirian co-op.'
  s.description      = 'Nearby discovery and a reliable byte channel over peer-to-peer Wi-Fi and Bluetooth for two-player local co-op.'
  s.homepage         = 'https://github.com/lioilsources/Kiran'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Kirian' => 'oldrich.vorechovsky.jr@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.frameworks       = 'MultipeerConnectivity'
  s.swift_version    = '5.0'

  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '11.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
