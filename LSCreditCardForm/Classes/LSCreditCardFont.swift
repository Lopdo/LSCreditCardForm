//
//  LSCreditCardFont.swift
//  LSCreditCardForm
//
//  Created by Lope on 20/03/2018.
//

import Foundation

class LSCreditCardFont {

	static func registerFont() {

		guard let fontURL = Bundle(for: LSCreditCardView.self).url(forResource: "CreditCard", withExtension: "ttf") else {
			print("Couldn't find font CreditCard")
			return
		}

		guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
			print("Couldn't load data from the font CreditCard")
			return
		}

		guard let font = CGFont(fontDataProvider) else {
			print("Couldn't create font from data")
			return
		}

		var error: Unmanaged<CFError>?
		let success = CTFontManagerRegisterGraphicsFont(font, &error)
		guard success else {
			print("Error registering font: maybe it was already registered.")
			return
		}
	}

	static func convertTextToSmallNumbers(text: String) -> String {
		var result = ""
		let mapping: [Character: Character] = ["1": "a", "2": "b", "3": "c", "4": "d", "5": "e", "6": "f", "7": "g", "8": "h", "9": "i", "0": "j"]
		for i in 0..<text.count {
			let character = text[text.index(text.startIndex, offsetBy: i)]
			if let smallDigit = mapping[character] {
				result.append(smallDigit)
			} else {
				result.append(character)
			}
		}

		return result
	}

}

extension UIImage {

	class func image(from string: String, attributes: [NSAttributedStringKey: Any]?) -> UIImage? {
		let size = string.size(withAttributes: attributes)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		let rect = CGRect(origin: .zero, size: size)
		string.draw(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}

	func applyEmboss() -> UIImage {

		let embossTexture = UIImage(named: "texture_emboss", in: Bundle(for: LSCreditCardView.self), compatibleWith: nil)!
		
		// Create filters
		guard let heightMapFilter = CIFilter(name: "CIHeightFieldFromMask") else {
			return self
		}
		guard let shadedMaterialFilter = CIFilter(name: "CIShadedMaterial") else {
			return self
		}

		// Filters chain
		heightMapFilter.setValue(CIImage(image: self),
								 forKey: kCIInputImageKey)

		guard let heightMapFilterOutput = heightMapFilter.outputImage else {
			return self
		}

		shadedMaterialFilter.setValue(heightMapFilterOutput,
									  forKey: kCIInputImageKey)
		shadedMaterialFilter.setValue(CIImage(image: embossTexture),
									  forKey: "inputShadingImage")
		// Catch output
		guard let filteredImage = shadedMaterialFilter.outputImage else {
			return self
		}

		let img = UIImage(ciImage: filteredImage, scale: UIScreen.main.scale, orientation: .up)
		return img

	}
}

