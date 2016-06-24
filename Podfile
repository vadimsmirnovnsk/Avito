source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
# use_frameworks!

workspace 'Avito.xcworkspace'

def import_common
	pod 'libextobjc'
end

target 'Avito' do
	import_common
	pod 'ReactiveCocoa', '~> 2.5'
	pod 'Masonry'
	pod 'AFNetworking', '~> 2.5'
	project 'Avito.xcodeproj'
end

target 'AvitoTests' do
	import_common
	pod 'Kiwi'
	project 'Avito.xcodeproj'
end