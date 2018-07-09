#
#  Be sure to run `pod spec lint ryIm.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "ryIm"
  s.version      = "0.0.4"
  s.summary      = "My ryIm."
  s.description  = <<-DESC
                        here is description.
                       DESC

  s.homepage     = "https://github.com/ChenArno/ryIm-eros"
  s.license = "MIT"
  s.author             = { "ChenArno" => "517625126@qq.com" }

  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/ChenArno/ryIm-eros.git", :tag => s.version.to_s }

  s.source_files  = "Source", "Source/*.{h,m}"
  #s.exclude_files = "Source/Exclude"
  s.requires_arc = true
  s.resources = "Source/Resources/*.png"
  s.dependency 'RongCloudIM/IMLib', '~> 2.8.3'
  s.dependency 'RongCloudIM/IMKit', '~> 2.8.3'
end
