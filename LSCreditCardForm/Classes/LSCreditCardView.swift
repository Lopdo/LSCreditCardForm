//
//  LSCreditCardView.swift
//  LSCreditCardForm
//
//  Created by Lope on 16/03/2018.
//

import UIKit

public class LSCreditCardView: UIView {

	private var imgViewBackground: UIImageView!
	private var imgViewNumber: UIImageView!
	private var imgViewExpiration: UIImageView!
	private var imgViewName: UIImageView!
	private var lblCVV: UILabel!

	private var lblCardHolderTitle: UILabel!
	private var lblExpirationTitle: UILabel!

	private var constraintNumberLeading: NSLayoutConstraint!
	private var constraintNumberTop: NSLayoutConstraint!
	private var constraintNameLeading: NSLayoutConstraint!
	private var constraintNameTop: NSLayoutConstraint!
	private var constraintExpirationLeading: NSLayoutConstraint!
	private var constraintExpirationTop: NSLayoutConstraint!
	private var constraintNameTitleLeading: NSLayoutConstraint!
	private var constraintNameTitleTop: NSLayoutConstraint!
	private var constraintExpirationTitleLeading: NSLayoutConstraint!
	private var constraintExpirationTitleTop: NSLayoutConstraint!
	private var constraintCVVTop: NSLayoutConstraint!
	private var constraintCVVLeading: NSLayoutConstraint!
	private var constraintCVVWidth: NSLayoutConstraint!
	private var constraintCVVHeight: NSLayoutConstraint!

	private var resizeRatio: CGFloat = 1

	private var card: LSCreditCard?
	private var cardType: LSCreditCardType = .unknown

	private var facingFront = true
	private var inTransition = false


	public init() {
		super.init(frame: CGRect.zero)

		translatesAutoresizingMaskIntoConstraints = false

		imgViewBackground = UIImageView(image: UIImage(named: "cc_template", in: Bundle(for: LSCreditCardView.self), compatibleWith: nil)!)
		imgViewBackground.translatesAutoresizingMaskIntoConstraints = false
		addSubview(imgViewBackground)

		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imgView]|", options: [], metrics: nil, views: ["imgView": imgViewBackground]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgView]|", options: [], metrics: nil, views: ["imgView": imgViewBackground]))

		addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.63, constant: 0))

		LSCreditCardFont.registerFont()

		imgViewNumber = UIImageView()
		imgViewNumber.translatesAutoresizingMaskIntoConstraints = false
		addSubview(imgViewNumber)

		constraintNumberLeading = NSLayoutConstraint(item: imgViewNumber, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 32)
		constraintNumberTop = NSLayoutConstraint(item: imgViewNumber, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 96)
		addConstraint(constraintNumberLeading)
		addConstraint(constraintNumberTop)

		imgViewExpiration = UIImageView()
		imgViewExpiration.translatesAutoresizingMaskIntoConstraints = false
		addSubview(imgViewExpiration)

		constraintExpirationLeading = NSLayoutConstraint(item: imgViewExpiration, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 244)
		constraintExpirationTop = NSLayoutConstraint(item: imgViewExpiration, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 166)
		addConstraint(constraintExpirationLeading)
		addConstraint(constraintExpirationTop)

		imgViewName = UIImageView()
		imgViewName.translatesAutoresizingMaskIntoConstraints = false
		addSubview(imgViewName)

		constraintNameLeading = NSLayoutConstraint(item: imgViewName, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 32)
		constraintNameTop = NSLayoutConstraint(item: imgViewName, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 166)
		addConstraint(constraintNameLeading)
		addConstraint(constraintNameTop)

		let cvvWrapView = UIView()
		cvvWrapView.translatesAutoresizingMaskIntoConstraints = false
		cvvWrapView.backgroundColor = UIColor.clear
		addSubview(cvvWrapView)

		constraintCVVLeading = NSLayoutConstraint(item: cvvWrapView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 24)
		constraintCVVTop = NSLayoutConstraint(item: cvvWrapView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 100)
		addConstraint(constraintCVVLeading)
		addConstraint(constraintCVVTop)

		constraintCVVWidth = NSLayoutConstraint(item: cvvWrapView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
		constraintCVVHeight = NSLayoutConstraint(item: cvvWrapView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)
		cvvWrapView.addConstraint(constraintCVVWidth)
		cvvWrapView.addConstraint(constraintCVVHeight)

		lblCVV = UILabel()
		lblCVV.translatesAutoresizingMaskIntoConstraints = false
		lblCVV.font = UIFont.systemFont(ofSize: 14)
		lblCVV.textColor = UIColor.black
		lblCVV.text = ""
		lblCVV.transform = CGAffineTransform(a: 1, b: 0, c: -0.25, d: 1, tx: 0, ty: 0).scaledBy(x: -0.8, y: 1)
		lblCVV.isHidden = true
		cvvWrapView.addSubview(lblCVV)

		cvvWrapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lbl]|", options: [], metrics: nil, views: ["lbl": lblCVV]))
		cvvWrapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbl]|", options: [], metrics: nil, views: ["lbl": lblCVV]))

		lblCardHolderTitle = UILabel()
		lblCardHolderTitle.translatesAutoresizingMaskIntoConstraints = false
		lblCardHolderTitle.font = UIFont.systemFont(ofSize: 10)
		lblCardHolderTitle.textColor = UIColor.white
		lblCardHolderTitle.text = "CARD HOLDER"
		addSubview(lblCardHolderTitle)

		lblExpirationTitle = UILabel()
		lblExpirationTitle.translatesAutoresizingMaskIntoConstraints = false
		lblExpirationTitle.font = UIFont.systemFont(ofSize: 10)
		lblExpirationTitle.textColor = UIColor.white
		lblExpirationTitle.text = "EXPIRES"
		addSubview(lblExpirationTitle)

		constraintNameTitleLeading = NSLayoutConstraint(item: lblCardHolderTitle, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 32)
		constraintNameTitleTop = NSLayoutConstraint(item: lblCardHolderTitle, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 148)
		addConstraint(constraintNameTitleLeading)
		addConstraint(constraintNameTitleTop)

		constraintExpirationTitleLeading = NSLayoutConstraint(item: lblExpirationTitle, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 244)
		constraintExpirationTitleTop = NSLayoutConstraint(item: lblExpirationTitle, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 148)
		addConstraint(constraintExpirationTitleLeading)
		addConstraint(constraintExpirationTitleTop)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		resizeRatio = self.frame.width / 333

		constraintNumberLeading.constant = 32 * resizeRatio
		constraintNumberTop.constant = 96 * resizeRatio
		constraintExpirationLeading.constant = 244 * resizeRatio
		constraintExpirationTop.constant = 166 * resizeRatio
		constraintNameLeading.constant = 32 * resizeRatio
		constraintNameTop.constant = 166 * resizeRatio
		constraintCVVLeading.constant = 24 * resizeRatio
		constraintCVVTop.constant = 100 * resizeRatio
		constraintCVVWidth.constant = 32 * resizeRatio
		constraintCVVHeight.constant = 16 * resizeRatio
		constraintNameTitleLeading.constant = 32 * resizeRatio
		constraintNameTitleTop.constant = 148 * resizeRatio
		constraintExpirationTitleLeading.constant = 244 * resizeRatio
		constraintExpirationTitleTop.constant = 148 * resizeRatio

		lblCVV.font = UIFont.systemFont(ofSize: 14 * resizeRatio)
		lblCardHolderTitle.font = UIFont.systemFont(ofSize: 10 * resizeRatio)
		lblExpirationTitle.font = UIFont.systemFont(ofSize: 10 * resizeRatio)

		updateValues(creditCard: card)
	}

	func flipCard(toFront: Bool) {

		if inTransition {
			// if we get flip request while we are transition to different orientation, we reset animation
			// otherwise we let it play out
			// facingFront contains old value until animation finishes, so we reset it only if we want to flip
			// to orientation we are currently transitioning from
			if toFront == facingFront {
				// finish animation by reseting tranform to target transform
				layer.transform = CATransform3DMakeRotation(self.facingFront ? CGFloat.pi : 0, 0.0, 1.0, 0.0)

				facingFront = !facingFront
				inTransition = false

				updateCardContent()

			} else {
				return
			}
		}

		if toFront == facingFront {
			return
		}

		inTransition = true

		UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {

			var transformPerspective = CATransform3DIdentity
			transformPerspective.m34 = -1.0 / 500
			self.layer.transform = CATransform3DRotate(transformPerspective, self.facingFront ? CGFloat.pi : 0, 0.0, 1.0, 0.0)

		}) { finished in
			if finished {
				self.inTransition = false
				self.facingFront = !self.facingFront
			}
		}

		delay(0.15) {
			self.updateCardContent()
		}
	}

	private func updateCardContent() {
		let currentlyFacingFront: Bool
		if inTransition {
			currentlyFacingFront = !facingFront
		} else {
			currentlyFacingFront = facingFront
		}

		if currentlyFacingFront {
			imgViewBackground.image = cardType.imageFront
			imgViewBackground.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0)
		} else {
			imgViewBackground.image = cardType.imageBack
			imgViewBackground.layer.transform = CATransform3DMakeRotation(CGFloat.pi * 1, 0.0, 1.0, 0.0)
		}

		lblCVV.isHidden = currentlyFacingFront
		imgViewNumber.isHidden = !currentlyFacingFront
		imgViewExpiration.isHidden = !currentlyFacingFront
		imgViewName.isHidden = !currentlyFacingFront

		lblExpirationTitle.isHidden = !currentlyFacingFront
		lblCardHolderTitle.isHidden = !currentlyFacingFront
	}

	private func delay(_ delayInSeconds:Double, closure:@escaping ()->()) {
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
	}

	public func updateValues(creditCard: LSCreditCard?) {

		card = creditCard
		
		if let card = creditCard {
			lblCVV.text = card.cvv

			imgViewNumber.image = createImage(from: card.number)
			imgViewExpiration.image = createImage(from: LSCreditCardFont.convertTextToSmallNumbers(text: card.expiration))
			imgViewName.image = createImage(from: LSCreditCardFont.convertTextToSmallNumbers(text: card.cardHolderName.uppercased()))

			cardType = card.cardType
		} else {
			lblCVV.text = ""

			imgViewNumber.image = createImage(from: "")
			imgViewExpiration.image = createImage(from: "")
			imgViewName.image = createImage(from: "")

			cardType = .unknown
		}

		updateCardContent()
	}

	func createImage(from string: String) -> UIImage? {

		let stringAttributes: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Credit Card", size: 13 * resizeRatio)!,
															  .foregroundColor: UIColor.white]

		let image = UIImage.image(from: string, attributes: stringAttributes)

		#if targetEnvironment(simulator)
		return image
		#else
		if LSCreditCardFormConfig.CreditCard.applyEmboss {
			return image?.applyEmboss()
		} else {
			return image
		}
		#endif
	}
}
