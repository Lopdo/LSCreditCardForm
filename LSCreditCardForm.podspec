#
# Be sure to run `pod lib lint LSCreditCardForm.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'LSCreditCardForm'
s.version          = '1.1.1'
s.summary          = 'Simple and engaging credit card form'

s.description      = <<-DESC
Offer your users engaging way how to enter credit card detail. Task that is usually boring and bothersome can be lightened by presenting it in visually interesting way
DESC

s.homepage         = 'https://github.com/lopdo/LSCreditCardForm'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'lopdo' => 'lopenka@gmail.com' }
s.source           = { :git => 'https://github.com/lopdo/LSCreditCardForm.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'LSCreditCardForm/Classes/**/*'

s.resources = ["LSCreditCardForm/Assets/*.xcassets", "LSCreditCardForm/Assets/CreditCard.ttf"]

end

