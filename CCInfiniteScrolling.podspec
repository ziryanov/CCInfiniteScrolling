Pod::Spec.new do |s|
  s.name         = "CCInfiniteScrolling"
  s.version      = "0.2.1"
  s.summary      = "These UIScrollView categories makes it super easy to add infinite scrolling functionalities to any UIScrollView"
  s.description  = "These UIScrollView categories makes it super easy to add infinite scrolling functionalities to any UIScrollView (or any of its subclass)"
  s.homepage     = "https://github.com/ziryanov/CCInfiniteScrolling"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Ivan Ziryanov" => "ivan.ziryanov@gmail.com" }
  s.source       = { :git => "https://github.com/ziryanov/CCInfiniteScrolling.git", :tag => s.version.to_s }
  s.screenshot   = "https://raw.githubusercontent.com/ziryanov/CCInfiniteScrolling/master/1.gif"
  s.platform     = :ios, '6.0'
  s.source_files = 'Classes', 'Classes/*.{h,m}'
  s.requires_arc = true
  s.resources    = 'Resources/CCInfiniteScrolling.bundle'
  s.dependency 'UIView+TKGeometry'
  s.dependency 'JRSwizzle'
  s.dependency 'DProperty'
end
