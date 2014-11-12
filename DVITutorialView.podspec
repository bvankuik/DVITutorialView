#
# After upping the s.version, do the following
#
# $ pod lib lint
# $ git add -A && git commit -m "Release 0.x.0"
# $ git tag '0.2.0'
# $ git push --tags
# $ pod trunk push
#
#

Pod::Spec.new do |s|
  s.name             = "DVITutorialView"
  s.version          = "0.2.0"
  s.summary          = "An Auto Layout based paging tutorial"
  s.description      = <<-DESC
                       This tutorial view is meant to be added to a single
                       ViewController, to explain its user elements. While
                       swiping through the tutorial, each page exposes an
                       element in your user interface, and displays an
                       explanation.
                       DESC
  s.homepage         = "https://github.com/bvankuik/DVITutorialView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Bart van Kuik" => "bart@dutchvirtual.nl" }
  s.source           = { :git => "https://github.com/bvankuik/DVITutorialView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'DVITutorialView' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
