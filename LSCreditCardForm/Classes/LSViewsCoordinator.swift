//
//  ViewsCoordinator.swift
//  LSCreditCardForm
//
//  Created by Lope on 17/03/2018.
//

import Foundation

enum CCTextField {
	case number
	case expiration
	case cvv
	case name
}

class LSViewsCoordinator {

	weak var viewTextFields: LSTextFieldsView!
	weak var viewButtons: LSButtonsView!
	weak var viewCreditCard: LSCreditCardView!

	weak var delegate: LSCreditCardFormDelegate?

	var creditCard = LSCreditCard()

	init() { }

	func changeActiveTextField(field: CCTextField) {
		viewCreditCard.flipCard(toFront: field != .cvv)
		viewButtons.focusChanged(to: field)
		viewTextFields.focusChanged(to: field)
	}

	func updateCCNumber(_ newValue: String) {
		creditCard.number = newValue

		let trimmedNumber = newValue.replacingOccurrences(of: " ", with: "")

		if let type = delegate?.getCustomCardType(for: trimmedNumber) {
			creditCard.cardType = type
		} else {
			creditCard.cardType = LSCreditCardType.getType(cardNumber: trimmedNumber)
		}
		viewCreditCard.updateValues(creditCard: creditCard)
	}

	func updateCCExpiration(_ newValue: String) {
		creditCard.expiration = newValue
		viewCreditCard.updateValues(creditCard: creditCard)
	}

	func updateCCCVV(_ newValue: String) {
		creditCard.cvv = newValue
		viewCreditCard.updateValues(creditCard: creditCard)
	}

	func updateCCName(_ newValue: String) {
		creditCard.cardHolderName = newValue
		viewCreditCard.updateValues(creditCard: creditCard)
	}
}
