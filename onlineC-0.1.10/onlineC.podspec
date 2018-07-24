Pod::Spec.new do |s|
  s.name = "onlineC"
  s.version = "0.1.10"
  s.summary = "A short description of onlineC."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"Zydhjx"=>"1551433476@qq.com"}
  s.homepage = "https://github.com/Zydhjx/onlineC"
  s.description = "TODO: Add long description of the pod here."
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/onlineC.framework'
end
