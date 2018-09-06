//
//  LSButtonsView.swift
//  LSCreditCardForm
//
//  Created by Lope on 16/03/2018.
//

import UIKit

class LSButtonsView: UIView {

	weak var coordinator: LSViewsCoordinator!
	weak var delegate: LSCreditCardFormDelegate?

	private var buttonPrev: UIButton!
	private var buttonNext: UIButton!

	private var constraintNextFullWidth: NSLayoutConstraint!
	private var constraintNextHalfWidth: NSLayoutConstraint!
	private var constraintNextLeading: NSLayoutConstraint!
	private var constraintPrevLeading: NSLayoutConstraint!

	private var currentFocus: CCTextField = .number

	init(coordinator: LSViewsCoordinator) {
		super.init(frame: CGRect.zero)

		self.coordinator = coordinator
		coordinator.viewButtons = self

		backgroundColor = UIColor(red: 120.0 / 255.0, green: 171.0 / 255.0, blue: 70.0 / 255.0, alpha: 1)
		translatesAutoresizingMaskIntoConstraints = false

		buttonPrev = UIButton()
		buttonPrev.translatesAutoresizingMaskIntoConstraints = false
		buttonPrev.titleLabel?.font = LSCreditCardFormConfig.Buttons.font ?? UIFont.systemFont(ofSize: 16)
		buttonPrev.setTitle(LSCreditCardFormConfig.Buttons.localization.previous ?? "PREV", for: .normal)
		buttonPrev.setTitleColor(LSCreditCardFormConfig.Buttons.prevTextColor ?? UIColor.white, for: .normal)
		buttonPrev.backgroundColor = LSCreditCardFormConfig.Buttons.prevColor ?? UIColor.clear
		buttonPrev.addTarget(self, action: #selector(onPrevPressed), for: .touchUpInside)
		addSubview(buttonPrev)

		buttonNext = UIButton()
		buttonNext.translatesAutoresizingMaskIntoConstraints = false
		buttonNext.titleLabel?.font = LSCreditCardFormConfig.Buttons.font ?? UIFont.systemFont(ofSize: 16)
		buttonNext.setTitle(LSCreditCardFormConfig.Buttons.localization.next ?? "NEXT", for: .normal)
		buttonNext.setTitleColor(LSCreditCardFormConfig.Buttons.nextTextColor ?? UIColor.white, for: .normal)
		buttonNext.backgroundColor = LSCreditCardFormConfig.Buttons.nextColor ?? UIColor.clear
		buttonNext.addTarget(self, action: #selector(onNextPressed), for: .touchUpInside)
		addSubview(buttonNext)

		let views: [String: Any] = ["prev": buttonPrev,
									"next": buttonNext]

		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[prev][next]", options: [], metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[prev]|", options: [], metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[next]|", options: [], metrics: nil, views: views))

		addConstraint(NSLayoutConstraint(item: buttonPrev, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))

		constraintNextFullWidth = NSLayoutConstraint(item: buttonNext, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
		constraintNextFullWidth.priority = UILayoutPriority(500)
		addConstraint(constraintNextFullWidth)

		constraintNextHalfWidth = NSLayoutConstraint(item: buttonNext, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0)
		constraintNextHalfWidth.priority = UILayoutPriority(100)
		addConstraint(constraintNextHalfWidth)

		constraintPrevLeading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: buttonPrev, attribute: .leading, multiplier: 1, constant: 0)
		constraintPrevLeading.priority = UILayoutPriority(100)
		addConstraint(constraintPrevLeading)

		constraintNextLeading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: buttonNext, attribute: .leading, multiplier: 1, constant: 0)
		constraintNextLeading.priority = UILayoutPriority(900)
		addConstraint(constraintNextLeading)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func focusChanged(to field: CCTextField) {
		switch field {
		case .number:
			constraintNextLeading.priority = UILayoutPriority(900)
			constraintNextLeading.constant = 0
			constraintPrevLeading.priority = UILayoutPriority(100)
			constraintNextFullWidth.priority = UILayoutPriority(900)
			constraintNextHalfWidth.priority = UILayoutPriority(100)
		case .cvv:
			fallthrough
		case .expiration:
			fallthrough
		case .name:
			constraintNextLeading.priority = UILayoutPriority(100)
			constraintNextLeading.constant = 0
			constraintPrevLeading.priority = UILayoutPriority(900)
			constraintNextFullWidth.priority = UILayoutPriority(100)
			constraintNextHalfWidth.priority = UILayoutPriority(900)
		}

		setNeedsLayout()

		UIView.animate(withDuration: 0.2) {
			if field == .name {
				self.buttonNext.setTitle(LSCreditCardFormConfig.Buttons.localization.done ?? "DONE", for: .normal)
			} else {
				self.buttonNext.setTitle(LSCreditCardFormConfig.Buttons.localization.next ?? "NEXT", for: .normal)
			}
			self.layoutIfNeeded()
		}

		currentFocus = field
	}

	@objc func onPrevPressed() {
		switch currentFocus {
		case .expiration:
			coordinator.changeActiveTextField(field: .number)
		case .cvv:
			coordinator.changeActiveTextField(field: .expiration)
		case .name:
			coordinator.changeActiveTextField(field: .cvv)
		case .number:
			// do nothing when we are on .number
			break
		}
	}

	@objc func onNextPressed() {
		switch currentFocus {
		case .number:
			coordinator.changeActiveTextField(field: .expiration)
		case .expiration:
			coordinator.changeActiveTextField(field: .cvv)
		case .cvv:
			coordinator.changeActiveTextField(field: .name)
		case .name:
			delegate?.didCompleteForm(creditCard: coordinator.creditCard)
			break
		}
	}

	/*@objc func onDonePressed() {
		delegate?.didCompleteForm(creditCard: coordinator.creditCard)
	}*/
}
