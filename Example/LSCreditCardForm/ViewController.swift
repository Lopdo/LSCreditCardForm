//
//  ViewController.swift
//  LSCreditCardForm
//
//  Created by lopdo on 03/16/2018.
//  Copyright (c) 2018 lopdo. All rights reserved.
//

import UIKit
import LSCreditCardForm

class ViewController: UIViewController {

	@IBOutlet var constraintKeyboard: NSLayoutConstraint!
	@IBOutlet var viewCCForm: LSCreditCardFormView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardNotification),
											   name: NSNotification.Name.UIKeyboardWillChangeFrame,
											   object: nil)

		viewCCForm.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


	@objc func keyboardNotification(notification: NSNotification) {
		if let endFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
			constraintKeyboard.constant = endFrame.height
			view.setNeedsLayout()
			view.layoutIfNeeded()
		}
	}
}

extension ViewController: LSCreditCardFormDelegate {

	func didCompleteForm(creditCard: LSCreditCard) {
		print(creditCard.number)
		print(creditCard.expiration)
		print(creditCard.cardHolderName)
		print(creditCard.cvv)
	}
}
