Pod::Spec.new do |s|
  s.name             = 'FlowSDK'
  s.version          = '0.0.0'
  s.summary          = 'Flow blockchain swift SDK'

  s.homepage         = 'https://github.com/portto/flow-swift-sdk.swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Scott' => 'scott@portto.com' }
  s.source           = { :git => 'https://github.com/portto/flow-swift-sdk.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BloctoApp'

  s.swift_version = '5.0'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '11.0'
  s.watchos.deployment_target = '3.0'

  s.source_files = 'Sources/**/*'

end
