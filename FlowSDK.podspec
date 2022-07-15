Pod::Spec.new do |s|
  s.name             = 'FlowSDK'
  s.version          = '0.1.3'
  s.summary          = 'Flow blockchain swift SDK'

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

  s.default_subspec = 'FlowSDK'

  s.subspec "Crypto" do |ss|
    ss.source_files  = "Sources/Crypto/**/*"
    ss.dependency "CryptoSwift", "~> 1.5.1"
    ss.dependency "secp256k1Swift", "~> 0.7.3"
  end

  s.subspec "Protobuf" do |ss|
    ss.source_files  = "Sources/Protobuf/**/*"
    ss.dependency "gRPC-Swift", "~> 1.7.3"
  end

  s.subspec "FlowSDK" do |ss|
    ss.source_files  = "Sources/FlowSDK/**/*"
    ss.dependency "BigInt", "~> 5.2.0"
    ss.dependency "CryptoSwift", "~> 1.5.1"
    ss.dependency "Cadence", "~> 0.1.0"
    ss.dependency "FlowSDK/Protobuf"
    ss.dependency "FlowSDK/Crypto"
  end

end
