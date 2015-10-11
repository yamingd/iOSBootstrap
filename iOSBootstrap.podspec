#
# Be sure to run `pod lib lint iOSBootstrap.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "iOSBootstrap"
  s.version          = "1.1.0"
  s.summary          = "utility, security, delegate wrapper, protobuf support, realm support."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        utility, security, delegate wrapper, protobuf support, realm support etc.
                       DESC

  s.homepage         = "https://github.com/yamingd/iOSBootstrap"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Yaming" => "yamingd@qq.com" }
  s.source           = { :git => "https://github.com/yamingd/iOSBootstrap.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/yamingd'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.exclude_files = 'Pod/Classes/**/*.proto', 'Pod/Classes/**/*.sh'
  
  s.resource_bundles = {
    'iOSBootstrap' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'

  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'AFNetworkActivityLogger', '~> 2.0'
  s.dependency 'SDWebImage'
  s.dependency 'SSKeychain'
  s.dependency 'TMCache'
  s.dependency 'UIColor+FlatColors'
  s.dependency 'Realm'
  s.dependency 'ProtocolBuffers', '~> 1.9'
  s.dependency 'ZipArchive'
  s.dependency 'CocoaAsyncSocket'
  s.dependency 'HTKDynamicResizingCell'
  s.dependency 'UIImage+ImageCompress'
  s.dependency 'ArrayUtils'
  s.dependency 'QBImagePickerController'
  s.dependency 'NSDate+TimeAgo', '~> 1.0'
  s.dependency 'FMDB/SQLCipher'

end
