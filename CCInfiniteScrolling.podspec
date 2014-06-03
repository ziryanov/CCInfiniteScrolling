Pod::Spec.new do |s|
  s.name         = "CCInfinityScroll"
  s.version      = "0.1"
  s.summary      = "These UIScrollView categories makes it super easy to add infinite scrolling functionalities to any UIScrollView"
  s.description  = "These UIScrollView categories makes it super easy to add infinite scrolling functionalities to any UIScrollView (or any of its subclass)"
  s.homepage     = "https://github.com/ziryanov/CCInfinityScroll"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Ivan Ziryanov" => "ivan.ziryanov@gmail.com" }
  s.source       = { :git => "https://github.com/ziryanov/CCInfinityScroll.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.source_files = 'Classes', 'Classes/*.{h,m}'
  s.requires_arc = true
  s.dependency 'UIView+TKGeometry', 'JRSwizzle', 'DProperty'
  s.resources    = 'Resources/CCInfinityScroll.bundle'
  s.screenshot = "https://raw.githubusercontent.com/ziryanov/CCInfinityScroll/master/1.gif"
end
