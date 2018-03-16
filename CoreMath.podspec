
Pod::Spec.new do |s|
  s.name             = 'CoreMath'
  s.version          = '0.1.0'
  s.summary          = 'CoreMath is a Swift library containing many math concepts.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

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
