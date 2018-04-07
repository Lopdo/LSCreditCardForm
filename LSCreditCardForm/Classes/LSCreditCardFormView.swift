//
//  LSCreditCardFormView.swift
//  LSCreditCardForm
//
//  Created by Lope on 16/03/2018.
//

import UIKit

public protocol LSCreditCardFormDelegate: AnyObject {

	func didCompleteForm(creditCard: LSCreditCard)

}

public class LSCreditCardFormView: UIView {

	var viewTextFields: LSTextFieldsView!
	var viewCreditCardWrapper: LSCreditCardWrapperView!
	var viewButtons: LSButtonsView!

	public weak var delegate: LSCreditCardFormDelegate? {
		didSet {
			viewButtons.delegate = delegate
		}
	}

	private var coordinator: LSViewsCoordinator!

	public override init(frame: CGRect) {
		super.init(frame: frame)

		createViews()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		createViews()
	}

	private func createViews() {
		translatesAutoresizingMaskIntoConstraints = false

		coordinator = LSViewsCoordinator()

		viewTextFields = LSTextFieldsView(coordinator: coordinator)
		addSubview(viewTextFields)

		viewCreditCardWrapper = LSCreditCardWrapperView()
		addSubview(viewCreditCardWrapper)
		coordinator.viewCreditCard = viewCreditCardWrapper.viewCC

		viewButtons = LSButtonsView(coordinator: coordinator)
		addSubview(viewButtons)

		let views: [String: Any] = ["textFields": viewTextFields,
									"ccWrapper": viewCreditCardWrapper,
									"buttons": viewButtons]

		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[textFields]|", options: [], metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[ccWrapper]|", options: [], metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[buttons]|", options: [], metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[ccWrapper][textFields(70)][buttons(50)]|", options: [], metrics: nil, views: views))
	}
}
