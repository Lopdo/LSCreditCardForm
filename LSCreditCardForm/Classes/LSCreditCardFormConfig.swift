//
//  LSCreditCardFormConfig.swift
//  LSCreditCardForm
//
//  Created by Lope on 04/04/2018.
//

import Foundation

public struct LSCreditCardFormConfig {

	public struct CreditCard {

		// While Visa card numbers have usually 16 digits, they can officially go up to 19.
		// Because of this, we lose automatic jump to next field upon entering 16th digit.
		// If you still want that functionality, set the property to true. Users will still
		// be able to go back and enter rest of digits if they happen to have 19 digit CC
		public static var softLimitVisaTo16Digits = false

		// Controls emboss effect on CC number, expiration date and cardholder name values
		public static var applyEmboss = true

		// custom CC image overrides
		public static var imgVisaFront: UIImage? = nil
		public static var imgVisaBack: UIImage? = nil
		public static var imgMastercardFront: UIImage? = nil
		public static var imgMastercardBack: UIImage? = nil
		public static var imgMaestroFront: UIImage? = nil
		public static var imgMaestroBack: UIImage? = nil
		public static var imgAmericanExpressFront: UIImage? = nil
		public static var imgAmericanExpressBack: UIImage? = nil
		public static var imgDinersClubFront: UIImage? = nil
		public static var imgDinersClubBack: UIImage? = nil
		public static var imgDiscoverFront: UIImage? = nil
		public static var imgDiscoverBack: UIImage? = nil
		public static var imgJCBFront: UIImage? = nil
		public static var imgJCBBack: UIImage? = nil
		public static var imgEnRouteFront: UIImage? = nil
		public static var imgEnRouteBack: UIImage? = nil
		public static var imgUnknownFront: UIImage? = nil
		public static var imgUnknownBack: UIImage? = nil

		public static var imgFrontForCustomType: ((_ type: String) -> UIImage?)? = nil
		public static var imgBackForCustomType: ((_ type: String) -> UIImage?)? = nil

		// Customization of view sitting behing credit card, use backgroundView property
		// if you require something other than solid color (which can be set using backgroundColor)
		public static var backgroundView: UIView? = nil
		public static var backgroundColor: UIColor? = nil

		// Limit CC detection to following CC types only. User will still be able to enter
		// any credit card number, but image will not update if CC type is not in the list
		// To support all types, set property to nil
		public static var supportedTypes: [LSCreditCardType]? = nil
	}

	public struct TextFields {

		public static var font: UIFont? = nil
		public static var textColor: UIColor? = nil
		public static var backgroundColor: UIColor? = nil

	}

	public struct TextFieldLabels {

		public static var font: UIFont? = nil
		public static var textColorActive: UIColor? = nil
		public static var textColorInactive: UIColor? = nil

		public struct Localization {
			public var number: String? = nil
			public var expiryDate: String? = nil
			public var cvv: String? = nil
			public var name: String? = nil
		}

		public static var localization = Localization()
	}

	public struct Buttons {

		public static var font: UIFont? = nil
		public static var prevColor: UIColor? = nil
		public static var nextColor: UIColor? = nil
		public static var prevTextColor: UIColor? = nil
		public static var nextTextColor: UIColor? = nil

		public struct Localization {
			public var next: String? = nil
			public var previous: String? = nil
			public var done: String? = nil
		}

		public static var localization = Localization()
	}
}
