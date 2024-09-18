Pod::Spec.new do |s|
  s.name             = 'FlowSDK'
  s.version          = '0.7.0'
  s.summary          = 'Flow blockchain swift SDK'

  s.homepage         = 'https://github.com/portto/flow-swift-sdk'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Scott' => 'scott@portto.com' }
  s.source           = { :git => 'https://github.com/portto/flow-swift-sdk.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BloctoApp'

  s.swift_version = '5.0'
  s.ios.deployment_target = '13.0'

  s.default_subspec = 'FlowSDK'

  s.subspec "FlowSDK" do |ss|
    ss.source_files  = "Sources/FlowSDK/**/*"
    ss.dependency "BigInt", "~> 5.2.0"
    ss.dependency "CryptoSwift", "~> 1.5.1"
    ss.dependency "Cadence", "~> 0.7.0"
    ss.dependency "gRPC-Swiftp", "1.8.2"
    ss.dependency "SwiftProtobuf", '1.9.0'
    ss.dependency "secp256k1Swift", "~> 0.7.4"
  end

end
