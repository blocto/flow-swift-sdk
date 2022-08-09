Pod::Spec.new do |s|
  s.name             = 'Cadence'
  s.version          = '0.3.0'
  s.summary          = 'JSON-Cadence Data Interchange Format Wrapper'

  s.homepage         = 'https://github.com/portto/flow-swift-sdk'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Scott' => 'scott@portto.com' }
  s.source           = { :git => 'https://github.com/portto/flow-swift-sdk.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BloctoApp'

  s.swift_version = '5.0'
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'

  s.source_files  = "Sources/Cadence/**/*"
  s.dependency "BigInt", "~> 5.2.0"
  s.dependency "CryptoSwift", "~> 1.5.1"

end
