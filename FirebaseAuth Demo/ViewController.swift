//
//  ViewController.swift
//  FirebaseAuth Demo
//
//  Created by Pablo Pasqualino on 5/28/16.
//  Copyright © 2016 Cooliopas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import AlamofireImage

class ViewController: UIViewController {

	let userImagePlaceholder: UIImage = UIImage(named: "userPlaceholder")!
	let userLoggedInView: SwiftyGradient = SwiftyGradient()
	let userImage: UIImageView = UIImageView()
	let userNameLabel: UILabel = UILabel()
	let welcomeLabel: UILabel = UILabel()
	let signInButton: UIButton = UIButton()
	let signOutButton: UIButton = UIButton()

	var user: FIRUser?

	override func viewDidLoad() {
		super.viewDidLoad()

		configViews()

		FIRAuth.auth()?.addAuthStateDidChangeListener {

			(_, user) in

			if user != nil {

				self.user = user
				self.signedIn()

			} else {

				self.signedOut()

			}

		}

	}

	func configViews() {

		// set userLoggedInView with SwiftyGradient

		userLoggedInView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240)
		userLoggedInView.startColor = UIColor(red:25/255, green:142/255, blue:255/255, alpha:1)
		userLoggedInView.endColor = UIColor(red:0/255, green:51/255, blue:208/255, alpha:1)
		userLoggedInView.alpha = 0
		self.view.addSubview(userLoggedInView)

		// set userImage

		userImage.frame = CGRect(x: ((self.view.frame.width - 120) / 2), y: 60, width: 120, height: 120)
		userImage.image = userImagePlaceholder
		userImage.layer.cornerRadius = 60
		userLoggedInView.addSubview(userImage)

		// set userName

		userNameLabel.frame = CGRect(x: 0, y: 190, width: self.view.frame.width, height: 30)
		userNameLabel.textAlignment = NSTextAlignment.Center
		userNameLabel.textColor = UIColor.whiteColor()
		userNameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		userLoggedInView.addSubview(userNameLabel)

		// set signOutButton

		signOutButton.setTitle("Sign Out", forState: UIControlState.Normal)
		signOutButton.addTarget(self, action: #selector(ViewController.signOut), forControlEvents: UIControlEvents.TouchUpInside)
		signOutButton.sizeToFit()
		signOutButton.frame.origin.x = self.view.frame.width - signOutButton.frame.size.width - 16
		signOutButton.frame.origin.y = 20
		userLoggedInView.addSubview(signOutButton)

		// set welcomeLabel

		welcomeLabel.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 60)
		welcomeLabel.textAlignment = NSTextAlignment.Center
		welcomeLabel.textColor = UIColor.blackColor()
		welcomeLabel.font = UIFont.systemFontOfSize(25)
		welcomeLabel.numberOfLines = 2
		welcomeLabel.text = "Welcome to\nFirebaseAuth Demo"
		welcomeLabel.alpha = 0
		self.view.addSubview(welcomeLabel)

		// set signInButton

		signInButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
		signInButton.setTitle("Sign In", forState: UIControlState.Normal)
		signInButton.addTarget(self, action: #selector(ViewController.signIn), forControlEvents: UIControlEvents.TouchUpInside)
		signInButton.sizeToFit()
		signInButton.frame.origin.x = (self.view.frame.width - signInButton.frame.width) / 2
		signInButton.frame.origin.y = 200
		signInButton.alpha = 0
		self.view.addSubview(signInButton)

	}

	func signedIn() {

		userLoggedInView.alpha = 1
		welcomeLabel.alpha = 0
		signInButton.alpha = 0

		userNameLabel.text = user!.displayName

		var photoURL: NSURL?

		if let providerData = user!.providerData.first {

			if providerData.providerID == "facebook.com" {

				let uid = providerData.uid
				photoURL = NSURL(string: "https://graph.facebook.com/\(uid)/picture?width=300")

			} else if providerData.providerID == "google.com" {

				photoURL = NSURL(string: (providerData.photoURL?.absoluteString.stringByReplacingOccurrencesOfString("s96-c/photo.jpg", withString: "photo.jpg?sz=250"))!)

			}

		}

		if photoURL != nil {

			userImage.af_setImageWithURL(
				photoURL!,
				placeholderImage: userImagePlaceholder,
				imageTransition: .CrossDissolve(0.2)
			)

		} else {

			userImage.image = userImagePlaceholder

		}

	}

	func signedOut() {

		userLoggedInView.alpha = 0
		welcomeLabel.alpha = 1
		signInButton.alpha = 1

	}

	func signIn() {

		if let authUI = FIRAuthUI.authUI() {

			let googleAuthUI = FIRGoogleAuthUI(clientID: FIRApp.defaultApp()!.options.clientID)
			let facebookAuthUI = FIRFacebookAuthUI(appID: NSBundle.mainBundle().infoDictionary!["FacebookAppID"] as! String)

			authUI.signInProviders = [googleAuthUI!,facebookAuthUI!]

			let authViewController = authUI.authViewController()

			self.presentViewController(authViewController, animated: true, completion: nil)

		}

	}

	func signOut() {

		try! FIRAuth.auth()!.signOut()

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}