//
//  LSCreditCardWrapperView.swift
//  LSCreditCardForm
//
//  Created by Lope on 16/03/2018.
//

import UIKit

class LSCreditCardWrapperView: UIView {

	var viewCC: LSCreditCardView!

	init() {
		super.init(frame: CGRect.zero)

		translatesAutoresizingMaskIntoConstraints = false

		if let bgView = LSCreditCardFormConfig.CreditCard.backgroundView {
			bgView.translatesAutoresizingMaskIntoConstraints = false
			bgView.layer.zPosition = -100000
			addSubview(bgView)

			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bgView]|", options: [], metrics: nil, views: ["bgView": bgView]))
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bgView]|", options: [], metrics: nil, views: ["bgView": bgView]))

		} else {
			backgroundColor = LSCreditCardFormConfig.CreditCard.backgroundColor ?? UIColor.lightGray
		}

		viewCC = LSCreditCardView()
		addSubview(viewCC)

		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=30-[viewCC]->=30-|", options: [], metrics: nil, views: ["viewCC": viewCC]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=30-[viewCC]->=30-|", options: [], metrics: nil, views: ["viewCC": viewCC]))
		addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: viewCC, attribute: .centerX, multiplier: 1, constant: 0))
		addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: viewCC, attribute: .centerY, multiplier: 1, constant: 0))
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
