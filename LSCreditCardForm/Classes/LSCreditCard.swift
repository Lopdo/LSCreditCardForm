//
//  LSCreditCard.swift
//  LSCreditCardForm
//
//  Created by Lope on 17/03/2018.
//

import Foundation

public class LSCreditCard {

	public var number: String = ""
	public var expiration: String = ""
	public var cvv: String = ""
	public var cardHolderName: String = ""

	public var cardType: LSCreditCardType = .unknown
}

public enum LSCreditCardType {

	case visa
	case mastercard
	case americanExpress
	case dinersClub
	case discover
	case enRoute
	case jcb
	case maestro

	case custom(String)
	
	case unknown

	private func getImageNameFront() -> String {
		switch self {
		case .visa: return "cc_template_visa"
		case .mastercard: return "cc_template_mastercard"
		case .americanExpress: return "cc_template_american_express"
		case .dinersClub: return "cc_template_dinners_club"
		case .discover: return "cc_template_discover"
		case .jcb: return "cc_template_jcb"
		case .maestro: return "cc_template_maestro"
		case .enRoute: return "cc_template_enroute"
		case .unknown: return "cc_template"
		case .custom(_): return ""
		}
	}

	private func getImageNameBack() -> String {
		switch self {
		case .visa: return "cc_template_visa_back"
		case .mastercard: return "cc_template_mastercard_back"
		case .americanExpress: return "cc_template_american_express_back"
		case .dinersClub: return "cc_template_dinners_club_back"
		case .discover: return "cc_template_discover_back"
		case .jcb: return "cc_template_jcb_back"
		case .maestro: return "cc_template_maestro_back"
		case .enRoute: return "cc_template_enroute_back"
		case .unknown: return "cc_template_back"
		case .custom(_): return ""
		}
	}

	var imageFront: UIImage? {
		get {

			let img: UIImage?

			switch self {
			case .visa: img = LSCreditCardFormConfig.CreditCard.imgVisaFront
			case .mastercard: img = LSCreditCardFormConfig.CreditCard.imgMastercardFront
			case .americanExpress: img = LSCreditCardFormConfig.CreditCard.imgAmericanExpressFront
			case .dinersClub: img = LSCreditCardFormConfig.CreditCard.imgDinersClubFront
			case .discover: img = LSCreditCardFormConfig.CreditCard.imgDiscoverFront
			case .jcb: img = LSCreditCardFormConfig.CreditCard.imgJCBFront
			case .maestro: img = LSCreditCardFormConfig.CreditCard.imgMaestroFront
			case .enRoute: img = LSCreditCardFormConfig.CreditCard.imgEnRouteFront
			case .unknown: img = LSCreditCardFormConfig.CreditCard.imgUnknownFront
			case .custom(let ccType): img = LSCreditCardFormConfig.CreditCard.imgFrontForCustomType?(ccType)
			}

			return img ?? UIImage(named: getImageNameFront(), in: Bundle(for: LSCreditCardView.self), compatibleWith: nil)
		}
	}

	var imageBack: UIImage? {
		get {

			let img: UIImage?

			switch self {
			case .visa: img = LSCreditCardFormConfig.CreditCard.imgVisaBack
			case .mastercard: img = LSCreditCardFormConfig.CreditCard.imgMastercardBack
			case .americanExpress: img = LSCreditCardFormConfig.CreditCard.imgAmericanExpressBack
			case .dinersClub: img = LSCreditCardFormConfig.CreditCard.imgDinersClubBack
			case .discover: img = LSCreditCardFormConfig.CreditCard.imgDiscoverBack
			case .jcb: img = LSCreditCardFormConfig.CreditCard.imgJCBBack
			case .maestro: img = LSCreditCardFormConfig.CreditCard.imgMaestroBack
			case .enRoute: img = LSCreditCardFormConfig.CreditCard.imgEnRouteBack
			case .unknown: img = LSCreditCardFormConfig.CreditCard.imgUnknownBack
			case .custom(let ccType): img = LSCreditCardFormConfig.CreditCard.imgBackForCustomType?(ccType)
			}

			return img ?? UIImage(named: getImageNameBack(), in: Bundle(for: LSCreditCardView.self), compatibleWith: nil)
		}
	}

	var regexDetection: NSRegularExpression {
		get {
			switch self {
			case .visa: return try! NSRegularExpression(pattern: "^4")
			case .mastercard: return try! NSRegularExpression(pattern: "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)")
			case .americanExpress: return try! NSRegularExpression(pattern: "^3[47]")
			case .dinersClub: return try! NSRegularExpression(pattern: "^3(?:0[0-59]{1}|[689])")
			case .discover: return try! NSRegularExpression(pattern: "^(6011|65|64[4-9]|62212[6-9]|6221[3-9]|622[2-8]|6229[01]|62292[0-5])")
			case .jcb: return try! NSRegularExpression(pattern: "^(?:2131|1800|35)")
			case .maestro: return try! NSRegularExpression(pattern: "^(5[06789]|6)")
			case .enRoute: return try! NSRegularExpression(pattern: "^(2014|2149)")
			case .unknown: return try! NSRegularExpression(pattern: "")
			case .custom(_): return try! NSRegularExpression(pattern: "")
			}
		}
	}

	var regexValidation: NSRegularExpression {
		get {
			switch self {
			case .visa: return try! NSRegularExpression(pattern: "^4[0-9]{6,}$")
			case .mastercard: return try! NSRegularExpression(pattern: "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]{0,}$")
			case .americanExpress: return try! NSRegularExpression(pattern: "^3[47][0-9]{0,}$")
			case .dinersClub: return try! NSRegularExpression(pattern: "^3(?:0[0-59]{1}|[689])[0-9]{0,}$")
			case .discover: return try! NSRegularExpression(pattern: "^(6011|65|64[4-9]|62212[6-9]|6221[3-9]|622[2-8]|6229[01]|62292[0-5])[0-9]{0,}$")
			case .jcb: return try! NSRegularExpression(pattern: "^(?:2131|1800|35)[0-9]{0,}$")
			case .maestro: return try! NSRegularExpression(pattern: "^(5[06789]|6)[0-9]{0,}$")
			case .enRoute: return try! NSRegularExpression(pattern: "^(2014|2149)[0-9]*$")
			case .unknown: return try! NSRegularExpression(pattern: "(?!.*)") // does not match anything
			case .custom(_): return try! NSRegularExpression(pattern: "(?!.*)") // does not match anything
			}
		}
	}

	var maxDigits: Int {
		get {
			switch self {
			case .visa: return 19
			case .mastercard: return 16
			case .americanExpress: return 15
			case .dinersClub: return 14
			case .discover: return 16
			case .jcb: return 19
			case .maestro: return 19
			case .enRoute: return 15
			case .unknown: return 16
			case .custom(_): return 16
			}
		}
	}

	var usualDigitsCount: Int {
		get {
			switch self {
			case .visa: return LSCreditCardFormConfig.CreditCard.softLimitVisaTo16Digits ? 16 : maxDigits
			default: return maxDigits
			}
		}
	}

	var getFormatter: ((String, Int) -> (String, Int))? {
		get {
			switch self {
			case .visa:
				fallthrough
			case .discover:
				fallthrough
			case .mastercard:
				fallthrough
			case .jcb:
				fallthrough
			case .maestro:
				return LSCreditCardType.format4444(cardNumber:cursorPosition:)
			case .americanExpress:
				fallthrough
			case .dinersClub:
				fallthrough
			case .enRoute:
				return LSCreditCardType.format465(cardNumber:cursorPosition:)
			case .unknown:
				return nil
			case .custom(_):
				return LSCreditCardType.format4444(cardNumber:cursorPosition:)
			}
		}
	}

	static func getType(cardNumber: String) -> LSCreditCardType {

		let types: [LSCreditCardType]
		if LSCreditCardFormConfig.CreditCard.supportedTypes != nil && !LSCreditCardFormConfig.CreditCard.supportedTypes!.isEmpty {
			types = LSCreditCardFormConfig.CreditCard.supportedTypes!
		} else {
			types = [.visa, .mastercard, .americanExpress, .dinersClub, .discover, .jcb, .maestro, .enRoute]
		}

		for t in types {
			let results = t.regexDetection.matches(in: cardNumber,
												   range: NSRange(cardNumber.startIndex..., in: cardNumber))

			if results.count > 0 {
				return t
			}
		}

		return .unknown
	}

	private static func format4444(cardNumber: String, cursorPosition: Int) -> (String, Int) {
		var numberWithSpaces = ""
		var newCursorPosition = cursorPosition

		for i in 0..<cardNumber.count {
			if i > 0 && (i % 4) == 0 {
				numberWithSpaces.append(" ")
				if i < cursorPosition {
					newCursorPosition += 1
				}
			}
			numberWithSpaces.append(cardNumber[cardNumber.index(cardNumber.startIndex, offsetBy: i)])
		}

		return (numberWithSpaces, newCursorPosition)
	}

	private static func format465(cardNumber: String, cursorPosition: Int) -> (String, Int) {
		var numberWithSpaces = ""
		var newCursorPosition = cursorPosition

		for i in 0..<cardNumber.count {
			if i == 4 || i == 10 {
				numberWithSpaces.append(" ")
				if i < cursorPosition {
					newCursorPosition += 1
				}
			}
			numberWithSpaces.append(cardNumber[cardNumber.index(cardNumber.startIndex, offsetBy: i)])
		}

		return (numberWithSpaces, newCursorPosition)
	}

}
