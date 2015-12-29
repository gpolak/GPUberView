Pod::Spec.new do |s|

  s.name         = "GPUberView"
  s.version      = "1.1.5"
  s.summary      = "Summon Uber from your app with 2 lines of code."
  s.homepage     = "https://github.com/gpolak/GPUberView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author       = { "George Polak" => "george.polak@gmail.com" }

  s.platform     = :ios, "7.1"

  s.source       = { :git => "https://github.com/gpolak/GPUberView.git", :tag => "1.1.5" }

  s.source_files = 'GPUberView'
  s.resources = 'GPUberView/*.{xib}', 'GPUberView/*.{png}'
  s.requires_arc = true

  s.frameworks = 'MapKit', 'CoreLocation'

  s.dependency 'JSONModel', "~> 1.0"
  s.dependency 'Bolts', "~> 1.1"
  s.dependency "PulsingHalo"
  s.dependency 'Masonry', '~> 0.6'
  s.dependency 'INTULocationManager', '~> 4.0'
  s.dependency 'BlocksKit', '~> 2.2'

end

