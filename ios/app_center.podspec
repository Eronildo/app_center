#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint app_center.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'app_center'
  s.version          = '0.0.1'
  s.summary          = 'A AppCenter Flutter plugin.'
  s.description      = <<-DESC
A AppCenter Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'AppCenter'
  s.dependency 'AppCenter/Analytics'
  s.dependency 'AppCenter/Crashes'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
