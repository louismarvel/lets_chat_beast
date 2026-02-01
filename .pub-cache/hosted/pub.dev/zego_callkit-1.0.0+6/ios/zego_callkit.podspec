#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint zego_callkit.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zego_callkit'
  s.version          = '1.0.0'
  s.summary          = 'ZEGO Callkit for Flutter.'
  s.description      = <<-DESC
  Callkit Flutter SDK is a flutter plugin wrapper based on ZIM native iOS SDK.
                       DESC
  s.homepage         = 'https://www.zego.im'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'developer@zego.im' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
