#
# Be sure to run `pod lib lint AGImageControls.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'AGImageControls'
s.version          = '0.1.5'
s.platform         = :ios, '9.0'
s.summary          = 'A short description of AGImageControls.'
s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/agilie/AGImageControls'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Agilie' => 'info@agilie.com' }
s.source           = { :git => 'https://github.com/agilie/AGImageControls.git', :tag => '0.1.5' }

s.ios.deployment_target = '9.0'
#s.requires_arc = true

s.source_files = 'AGImageControls/Classes/**/*.{swift,metal}'

s.resource_bundles = {
'AGImageControls' => ['AGImageControls/Assets/Fonts/*.ttf', 'AGImageControls/Assets/Images/*.png', 'AGImageControls/Assets/Images/*.pdf']
}

end
