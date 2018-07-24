#
# Be sure to run `pod lib lint onlineC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'onlineC'
  s.version          = '0.1.13'
  s.summary          = 'A short description of onlineC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Zydhjx/onlineC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zydhjx' => '1551433476@qq.com' }
  s.source           = { :git => 'https://github.com/Zydhjx/onlineC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'onlineC/Classes/**/*'
  
  s.resource_bundles = {
    'onlineC' => ['onlineC/Assets/*.png']
  }
  
  s.resources = ['onlineC/**/*.png', 'onlineC/**/*.xib', 'onlineC/**/*.plist', 'onlineC/**/*.xcassets', 'onlineC/**/*.json']
#  s.ios.vendored_frameworks = 'onlineC/Frameworks/**/*.framework'
  s.ios.vendored_frameworks  = ['Frameworks/**/*.framework', 'onlineC/Frameworks/**/*.framework']

  s.public_header_files = 'onlineC/Classes/**/OCSSessionGenerator.h'
  s.frameworks = 'UIKit', 'CoreGraphics', 'AVFoundation', 'Accelerate', 'AssetsLibrary', 'CoreMedia', 'Photos', 'CoreLocation'
  s.dependency 'AFNetworking'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'ObjectiveGumbo'
  s.dependency 'YYText'
  s.dependency 'SDWebImage'
  s.dependency 'SocketRocket'
  s.dependency 'TZImagePickerController'
end
