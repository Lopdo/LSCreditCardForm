//
//  LSTextFieldsView.swift
//  LSCreditCardForm
//
//  Created by Lope on 16/03/2018.
//

import UIKit

class LSTextFieldsView: UIView {

	private var scrollView: UIScrollView!

	private var tfNumber: UITextField!
	private var tfExpiration: UITextField!
	private var tfCardHolderName: UITextField!
	private var tfCVV: UITextField!

	private var lblNumber: UILabel!
	private var lblExpiration: UILabel!
	private var lblCardHolderName: UILabel!
	private var lblCVV: UILabel!

	// CC formatter helpers
	private var previousNumberTextFieldContent: String = ""
	private var previousNumberSelection: UITextRange?
	private var previousExpirationTextFieldContent: String = ""
	private var previousExpirationSelection: UITextRange?

	weak var coordinator: LSViewsCoordinator!

	private var changingResponderFromCode: Bool = false

	init(coordinator: LSViewsCoordinator) {
		super.init(frame: CGRect.zero)

		translatesAutoresizingMaskIntoConstraints = false

		self.coordinator = coordinator
		coordinator.viewTextFields = self
		
		backgroundColor = LSCreditCardFormConfig.TextFields.backgroundColor ?? UIColor.white

		scrollView = NoAutoScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.backgroundColor = UIColor.clear
		addSubview(scrollView)

		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": scrollView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": scrollView]))

		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.backgroundColor = UIColor.clear
		scrollView.addSubview(contentView)

		scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": contentView]))
		scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": contentView]))
		scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: 0))

		tfNumber = UITextField()
		tfNumber.keyboardType = .numberPad
		setup(textField: tfNumber)
		contentView.addSubview(tfNumber)

		tfExpiration = UITextField()
		tfExpiration.keyboardType = .numberPad
		setup(textField: tfExpiration)
		contentView.addSubview(tfExpiration)

		tfCVV = UITextField()
		tfCVV.keyboardType = .numberPad
		setup(textField: tfCVV)
		contentView.addSubview(tfCVV)

		tfCardHolderName = UITextField()
		tfCardHolderName.autocorrectionType = .no
		tfCardHolderName.autocapitalizationType = .words
		setup(textField: tfCardHolderName)
		contentView.addSubview(tfCardHolderName)

		lblNumber = UILabel()
		setup(textFieldLabel: lblNumber)
		lblNumber.text = "CARD NUMBER"
		contentView.addSubview(lblNumber)

		lblExpiration = UILabel()
		setup(textFieldLabel: lblExpiration)
		lblExpiration.text = "EXPIRY DATE"
		contentView.addSubview(lblExpiration)

		lblCardHolderName = UILabel()
		setup(textFieldLabel: lblCardHolderName)
		lblCardHolderName.text = "CARD HOLDER'S NAME"
		contentView.addSubview(lblCardHolderName)

		lblCVV = UILabel()
		setup(textFieldLabel: lblCVV)
		lblCVV.text = "CVV/CVC"
		contentView.addSubview(lblCVV)

		let views: [String: Any] = ["number": tfNumber,
									"expiration": tfExpiration,
									"cvv": tfCVV,
									"name": tfCardHolderName,
									"lblNumber": lblNumber,
									"lblExpiration": lblExpiration,
									"lblName": lblCardHolderName,
									"lblCVV": lblCVV]

		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[number(220)]-20-[expiration(100)]-20-[cvv(80)]-20-[name(250)]-20-|", options: [], metrics: nil, views: views))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-6-[lblNumber]-4-[number]-10-|", options: [], metrics: nil, views: views))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-6-[lblExpiration]-4-[expiration]-10-|", options: [], metrics: nil, views: views))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-6-[lblName]-4-[name]-10-|", options: [], metrics: nil, views: views))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-6-[lblCVV]-4-[cvv]-10-|", options: [], metrics: nil, views: views))
		contentView.addConstraint(NSLayoutConstraint(item: lblNumber, attribute: .leading, relatedBy: .equal, toItem: tfNumber, attribute: .leading, multiplier: 1, constant: 0))
		contentView.addConstraint(NSLayoutConstraint(item: lblExpiration, attribute: .leading, relatedBy: .equal, toItem: tfExpiration, attribute: .leading, multiplier: 1, constant: 0))
		contentView.addConstraint(NSLayoutConstraint(item: lblCardHolderName, attribute: .leading, relatedBy: .equal, toItem: tfCardHolderName, attribute: .leading, multiplier: 1, constant: 0))
		contentView.addConstraint(NSLayoutConstraint(item: lblCVV, attribute: .leading, relatedBy: .equal, toItem: tfCVV, attribute: .leading, multiplier: 1, constant: 0))

	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	private func setup(textField: UITextField) {
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.font = LSCreditCardFormConfig.TextFields.font ?? UIFont.systemFont(ofSize: 16)
		textField.textColor = LSCreditCardFormConfig.TextFields.textColor ?? UIColor.black
		textField.delegate = self
		textField.backgroundColor = UIColor.clear

		textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
	}

	private func setup(textFieldLabel label: UILabel) {
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = LSCreditCardFormConfig.TextFieldLabels.textColorInactive ?? UIColor.gray
		label.font = LSCreditCardFormConfig.TextFieldLabels.font ?? UIFont.systemFont(ofSize: 12)
		label.setContentHuggingPriority(UILayoutPriority(rawValue: 800), for: .vertical)
	}

	func focusChanged(to field: CCTextField) {

		changingResponderFromCode = true

		let newContentOffset: CGFloat

		let colorInactive = LSCreditCardFormConfig.TextFieldLabels.textColorInactive ?? UIColor.gray
		let colorActive = LSCreditCardFormConfig.TextFieldLabels.textColorActive ?? UIColor.black

		lblNumber.textColor = colorInactive
		lblExpiration.textColor = colorInactive
		lblCVV.textColor = colorInactive
		lblCardHolderName.textColor = colorInactive

		switch field {
		case .number:
			tfNumber.becomeFirstResponder()
			lblNumber.textColor = colorActive
			newContentOffset = 0
		case .expiration:
			tfExpiration.becomeFirstResponder()
			lblExpiration.textColor = colorActive
			newContentOffset = 240
		case .cvv:
			tfCVV.becomeFirstResponder()
			lblCVV.textColor = colorActive
			newContentOffset = 240
		case .name:
			tfCardHolderName.becomeFirstResponder()
			lblCardHolderName.textColor = colorActive
			newContentOffset = scrollView.contentSize.width - scrollView.bounds.size.width
		}

		scrollView.setContentOffset(CGPoint(x: newContentOffset, y: 0), animated: true)

		changingResponderFromCode = false
	}
}

extension LSTextFieldsView: UITextFieldDelegate {

	@objc func textFieldDidChange(_ sender: UITextField) {

		if sender == tfNumber {

			// In order to make the cursor end up positioned correctly, we need to
			// explicitly reposition it after we inject spaces into the text.
			// targetCursorPosition keeps track of where the cursor needs to end up as
			// we modify the string, and at the end we set the cursor position to it.
			let targetCursorPosition = sender.offset(from: sender.beginningOfDocument, to: sender.selectedTextRange!.start)
			let (numberWithoutSpaces, newCursorPosition) = removeNonDigits(from: sender.text!, preserveCursorAt: targetCursorPosition)

			if numberWithoutSpaces.count > coordinator.creditCard.cardType.maxDigits {
				sender.text = previousNumberTextFieldContent
				sender.selectedTextRange = previousNumberSelection
				return
			}

			if let formatter = coordinator.creditCard.cardType.getFormatter {
				let (cardNumberWithSpaces, finalCursorPosition) = formatter(numberWithoutSpaces, newCursorPosition)
				sender.text = cardNumberWithSpaces

				if let targetPosition = sender.position(from: sender.beginningOfDocument, offset: finalCursorPosition) {
					sender.selectedTextRange = sender.textRange(from: targetPosition, to: targetPosition)
				}
			}

			coordinator.updateCCNumber(sender.text!)

			if numberWithoutSpaces.count == coordinator.creditCard.cardType.usualDigitsCount ||
				numberWithoutSpaces.count == coordinator.creditCard.cardType.maxDigits {
				
				coordinator.changeActiveTextField(field: .expiration)
			}
		}
		if sender == tfExpiration {

			// In order to make the cursor end up positioned correctly, we need to
			// explicitly reposition it after we inject slash into the text.
			// targetCursorPosition keeps track of where the cursor needs to end up as
			// we modify the string, and at the end we set the cursor position to it.
			let targetCursorPosition = sender.offset(from: sender.beginningOfDocument, to: sender.selectedTextRange!.start)
			let (dateWithoutSlashes, newCursorPosition) = removeNonDigits(from: sender.text!, preserveCursorAt: targetCursorPosition)

			if dateWithoutSlashes.count > 4 {
				sender.text = previousExpirationTextFieldContent
				sender.selectedTextRange = previousExpirationSelection
				return
			}

			let (dateWithSlashes, finalCursorPosition) = formatExpirationDate(text: dateWithoutSlashes, cursorPosition: newCursorPosition)
			sender.text = dateWithSlashes

			if let targetPosition = sender.position(from: sender.beginningOfDocument, offset: finalCursorPosition) {
				sender.selectedTextRange = sender.textRange(from: targetPosition, to: targetPosition)
			}

			coordinator.updateCCExpiration(sender.text!)

			if dateWithoutSlashes.count == 4 {
				coordinator.changeActiveTextField(field: .cvv)
			}

		}
		if sender == tfCVV {
			coordinator.updateCCCVV(sender.text!)

			if sender.text!.count == 3 {
				coordinator.changeActiveTextField(field: .name)
			}
		}
		if sender == tfCardHolderName {
			coordinator.updateCCName(sender.text!)
		}
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		if changingResponderFromCode {
			return
		}

		if textField == tfNumber {
			coordinator.changeActiveTextField(field: .number)
		} else if textField == tfExpiration {
			coordinator.changeActiveTextField(field: .expiration)
		} else if textField == tfCVV {
			coordinator.changeActiveTextField(field: .cvv)
		} else {
			coordinator.changeActiveTextField(field: .name)
		}
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		if textField == tfNumber {
			previousNumberTextFieldContent = textField.text!
			previousNumberSelection = textField.selectedTextRange
			return true
		}

		if textField == tfExpiration {
			previousExpirationTextFieldContent = textField.text!
			previousExpirationSelection = textField.selectedTextRange
			return true
		}

		//check if the field has exceeded its maximum length

		//this validation is required to avoid a crash in the case of undo
		let currentCharacterCount = textField.text?.count ?? 0
		if (range.length + range.location > currentCharacterCount) {
			return false
		}

		let newLength = currentCharacterCount + string.count - range.length

		if textField == tfCVV {
			return newLength <= 3
		} else if textField == tfCardHolderName {
			// always return true if deleting
			if string.count == 0 {
				return true
			}
			// only allow insertion of allowed characters (ascii chars from range 0x20...0x5f)
			let asciiSet = Array(0x20...0x5f).map { return String(Character(UnicodeScalar($0))) }.joined()
			let set = CharacterSet(charactersIn: asciiSet)
			if string.uppercased().rangeOfCharacter(from: set) != nil {
				return newLength <= 21
			} else {
				return false
			}
		} else {
			return false
		}
	}

	// Formatter helper methods
	private func removeNonDigits(from cardNumber: String, preserveCursorAt cursorPosition: Int) -> (String, Int) {
		var resultNumber = ""
		var newCursorPosition = cursorPosition

		for i in 0..<cardNumber.count {
			let character = cardNumber[cardNumber.index(cardNumber.startIndex, offsetBy: i)]

			if CharacterSet.decimalDigits.contains(character.unicodeScalars[character.unicodeScalars.startIndex]) {
				resultNumber.append(character)
			} else {
				if i < cursorPosition {
					newCursorPosition -= 1
				}
			}
		}

		return (resultNumber, newCursorPosition)
	}

	private func formatExpirationDate(text: String, cursorPosition: Int) -> (String, Int) {
		var numberWithSlashes = ""
		var newCursorPosition = cursorPosition

		for i in 0..<text.count {
			if i == 2 {
				numberWithSlashes.append("/")
				if i < cursorPosition {
					newCursorPosition += 1
				}
			}
			numberWithSlashes.append(text[text.index(text.startIndex, offsetBy: i)])
		}

		return (numberWithSlashes, newCursorPosition)
	}

}

private class NoAutoScrollView: UIScrollView {

	override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
		// do nothing
	}

}
