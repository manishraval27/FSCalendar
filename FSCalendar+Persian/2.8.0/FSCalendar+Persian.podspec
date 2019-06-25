Pod::Spec.new do |s|

  s.name             = "FSCalendar+Persian"
  s.version          = "2.8.0"
  s.summary          = "Persian version of FSCalendar. A superiorly awesome iOS7+ calendar control, compatible with Objective-C and Swift."
  
  s.homepage         = "https://github.com/Husseinhj/FSCalendar"
  s.screenshots      = "https://raw.githubusercontent.com/Husseinhj/FSCalendar/master/ScreenShots/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-03-01%20at%2016.46.44.png","https://github.com/Husseinhj/FSCalendar/raw/master/ScreenShots/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-03-01%20at%2015.26.50.png"
  s.license          = 'MIT'
  s.author           = { "Hussein Habibi Juybari" => "hussein.juybari@gmail.com" }
  s.source           = { :git => "https://github.com/Husseinhj/FSCalendar.git", :tag => s.version.to_s }

  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.framework    = 'UIKit', 'QuartzCore'
  s.source_files = 'FSCalendar/*.{h,m}'

end
