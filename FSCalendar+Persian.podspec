Pod::Spec.new do |s|

  s.name             = "FSCalendar+Persian"
  s.version          = "2.9.3"
  s.summary          = "RTL (Persian and Arabic) version of FSCalendar. https://husseinhj.github.io/FSCalendar/"
  
  s.homepage         = "https://github.com/Husseinhj/FSCalendar"
  s.screenshots      = "https://github.com/Husseinhj/FSCalendar/raw/master/docs/Screenshots/English/DIY-Example-en.png", "https://raw.githubusercontent.com/Husseinhj/FSCalendar/master/docs/Screenshots/Persian/DIY-Example-fa.png", "https://github.com/Husseinhj/FSCalendar/raw/master/docs/Screenshots/Arabic/DIY-Example-ar.png"
  s.license          = 'MIT'
  s.author           = { "Hussein Habibi Juybari" => "hussein.juybari@gmail.com" }
  s.source           = { :git => "https://github.com/Husseinhj/FSCalendar.git", :tag => s.version.to_s }

  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.framework    = 'UIKit', 'QuartzCore'
  s.source_files = 'FSCalendar/*.{h,m}'

end
