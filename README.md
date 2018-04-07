# LSCreditCardForm

[![Version](https://img.shields.io/cocoapods/v/LSCreditCardForm.svg?style=flat)](http://cocoapods.org/pods/LSCreditCardForm)
[![License](https://img.shields.io/cocoapods/l/LSCreditCardForm.svg?style=flat)](http://cocoapods.org/pods/LSCreditCardForm)
[![Platform](https://img.shields.io/cocoapods/p/LSCreditCardForm.svg?style=flat)](http://cocoapods.org/pods/LSCreditCardForm)

Engaging credit card form that is simple to use.

## Demo

![demo-vid](cc.gif)

## Usage

To use LSCreditCardForm, simply add `LSCreditCardFormView` into your view controller and layout apropriately.
Contents of `LSCreditCardFormView` are dynamicaly resized and layout is updated on each view size change.
Use `LSCreditCardFormDelegate` to get values user entered into the form. Delegate protocol contains only one method
`didCompleteForm(creditCard: LSCreditCard)` that is called whenever user hits Done button. Library does not validate 
entered data except making sure that user did not enter invalid characters.

`LSCreditCardFormView` currently detects following credit card issuers:
VISA
Mastercard
AmericanExpress
DinersClub
Discover
enRoute
JCB
Maestro

## Customization

Various aspects of form can be customized using `LSCreditCardFormConfig` and it's subfields. Customization points include fonts, text colors, 
background colors and ability to provide custom credit card images. 
IMPORTANT: all customizations have to be made before `LSCreditCardFormView` gets instantiated

Textfield focus automatically changes when user enters maximum allowed number of characters. This works well in most cases, but causes
problems with VISA cards. Maximum number of digits for VISA credit cards is 19, but vast majority of cards consist of only 16 digits.
This would make entering VISA cards annoying so config has `CreditCard.softLimitVisaTo16Digits` that can be set to `true` 
to automatically skip to next textfield when user enters 16th digit. In rare cases when user wants to enter 19 digits, he can manually return
to number text field. 

If you wish to limit which credit cards get detected, override `CreditCard.supportedTypes` property by providing array of types you 
want to detect. User will still be able to enter any credit card number, disabling detection for certain types simply means that the credit
card image will not update and will remain on "unknown" credit card.

## Installation

LSCreditCardForm is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LSCreditCardForm'
```

## License

LSCreditCardForm is available under the MIT license. See the LICENSE file for more info.
