#
# Be sure to run `pod lib lint AssistantUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AssistantUI'
  s.version          = '0.1.1'
  s.summary          = 'A short description of AssistantUI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/congnq/AssistantUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cong nguyen' => 'congnq.hp@gmail.com' }
  s.source           = { :git => 'git@github.com:congnq/AssistantUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'AssistantUI/Classes/**/*'
  
  s.resource_bundles = {
      'AssistantUI' => ['AssistantUI/**/*.{xib,storyboard,xcassets,ttf}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'RxSwift', '~> 6.5.0'
  s.dependency 'RxCocoa', '~> 6.5.0'
  s.dependency 'RxDataSources', '~> 5.0'
  s.dependency 'SwifterSwift', '~> 5.2.0'
  s.dependency 'AssistantAPI', '0.1.5'
  s.dependency 'SwifterSwift', '~> 5.2.0'
  s.dependency 'SDWebImage', '~> 5.10.4'
end
