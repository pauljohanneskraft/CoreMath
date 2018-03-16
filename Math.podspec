
Pod::Spec.new do |s|
  s.name             = 'Math'
  s.version          = '0.1.0'
  s.summary          = 'Math implements a lot of math concept a Computer Science student learns about during their studies.'

  s.description      = <<-DESC
'Math' includes a lot of math concepts that might be helpful in projects, that for example rely on Complex Numbers, Discrete Fourier Transforms or Interpolation.
                       DESC

  s.homepage         = 'https://github.com/pauljohanneskraft/Math'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paul Kraft' => 'pauljohanneskraft@icloud.com' }
  s.source           = { :git => 'https://github.com/pauljohanneskraft/Math.git', :tag => s.version.to_s }

  s.platform = :osx
  s.osx.deployment_target = "10.10"
  s.source_files = 'Math/Classes/**/*'
end
