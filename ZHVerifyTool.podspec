#
#  Be sure to run `pod spec lint ZHVerifyTool.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

    s.name         = "ZHVerifyTool"
    s.version      = "1.0.1"
    s.summary      = "数据合规性判定"

    s.homepage     = "https://github.com/leezhihua/ZHVerifyTool"
    s.license      = { :type => "MIT", :file => "LICENSE" }

    s.authors      = {"leezhihua" => "leezhihua@yeah.net"}

    s.ios.deployment_target = "8.0"

    s.source       = { :git => "https://github.com/leezhihua/ZHVerifyTool.git", :tag => "#{s.version}" }

    s.source_files = "Pod/Classes/*.{h,m}"

    s.frameworks   =  "Foundation"

    s.requires_arc = true

end

