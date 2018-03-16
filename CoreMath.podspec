
Pod::Spec.new do |s|
  s.name             = 'CoreMath'
  s.version          = '0.1.1'
  s.summary          = 'CoreMath is a Swift library containing many math concepts.'

  s.description      = <<-DESC
If you need an implementation of Complex Numbers, Discrete Fourier Transform, Interpolation and many more, this is the library you have been looking for.
                       DESC

  s.homepage         = 'https://github.com/pauljohanneskraft/CoreMath'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paul Kraft' => 'pauljohanneskraft@icloud.com' }
  s.source           = { :git => 'https://github.com/pauljohanneskraft/CoreMath.git', :tag => s.version.to_s }

  s.platform = :osx
  s.osx.deployment_target = "10.10"

  s.source_files = 'CoreMath/Classes/**/*'
end
