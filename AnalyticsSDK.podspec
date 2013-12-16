Pod::Spec.new do |s|
  s.name         = "AnalyticsSDK"
  s.version      = "0.1"
  s.summary      = "A full analytics SDK for all iOS statistics tools. For example, UMeng, 百度统计, Google Analytics."

  s.description  = <<-DESC
                   To be a full analytics SDK for all iOS analytics tools. For example, UMeng, 百度统计, Google Analytics.

                   **v0.1**
                   Basic support Umeng, GoogleAnalytics.
                   DESC

  s.homepage     = "https://github.com/shjborage/AnalyticsSDK"
  s.license      = 'MIT'
  s.author       = { "Eric" => "shjborage@gmail.com" }
  # s.authors    = { "Eric" => "shjborage@gmail.com", "other author" => "email@address.com" }
  # s.platform   = :ios
  # s.platform   = :ios, '5.0'
  s.source       = { :git => "git@github.com:shjborage/AnalyticsSDK.git", :tag => "v0.1"}
  s.source_files = 'AnalyticsSDK'
  #s.frameworks   = 'SystemConfiguration', 'AnotherFramework'
  #s.library      = 'z'
  s.requires_arc = false

  s.dependency 'UMeng-Analytics',         '~> 2.2.0'
  s.dependency 'GoogleAnalytics-iOS-SDK', '~> 3.0.2'

end
