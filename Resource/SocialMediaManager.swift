//
//  SocialMediaManager.swift
//  Fevir
//
//  Created by Muhammad Jamshaid on 8/15/16.
//  Copyright © 2016 Muhammad Jamshaid. All rights reserved.
//

import UIKit
//import FacebookCore
import FacebookLogin
import FBSDKLoginKit
//import TwitterKit
import SVProgressHUD

class SocialMediaManager: NSObject {

	var successBlock: ((AnyObject) -> Void)? = nil
	var errorBlock: ((NSError) -> Void)? = nil

	func facebookSignup(_ viewController: UIViewController) {

		let loginManager = LoginManager()
        
//        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: viewController) { (loginResult) in
//
//        }
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: viewController) { loginResult in
			switch loginResult {
			case .failed(let error):
				print(error)
			case .cancelled:
				print("User cancelled login.")
			case .success:
				SVProgressHUD.show()
				FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,id,first_name,last_name,gender,picture"]).start(completionHandler: { (connection, result, error) -> Void in
					if (error == nil) {
						let fbDetails = result as! NSDictionary
						let facebookId = fbDetails.object(forKey: "id") as! String
						if let responseBlock = self.successBlock {

							let defaults = UserDefaults.standard
                        
							let params: [String: String] = [
//                                "data[api_key]": DefineMacros.API_KEY,
								"data[User][first_name]": ApplicationHelper.checkNull(fbDetails.object(forKey: "first_name") as! String),
								"data[User][last_name]": ApplicationHelper.checkNull(fbDetails.object(forKey: "last_name") as! String),
								"data[User][email]": ApplicationHelper.checkNull(fbDetails.object(forKey: "email") as! String),
								"data[User][facebook_id]": ApplicationHelper.checkNull(facebookId),
								"data[User][gender]": ApplicationHelper.checkNull(fbDetails.object(forKey: "gender") as! String),
								"data[User][picture]": "https://graph.facebook.com/" + facebookId + "/picture?width=500&height=500&return_ssl_resources=1",
                                
								"data[Device][device_type]": "ios",
//                                "data[Device][device_token]": defaults.object(forKey: DefineMacros.DEVICE_TOKEN) as! String
							]

							responseBlock(params as AnyObject);
						}

					}
				})

			}

		}

	}

//    func twitterSignup() {
//
//        Twitter.sharedInstance().logIn { session, error in
//            if (session != nil) {
//
//                SVProgressHUD.show()
//                let client = TWTRAPIClient.withCurrentUser()
//                let request = client.urlRequest(withMethod: "GET",
//                    url: "https://api.twitter.com/1.1/account/verify_credentials.json",
//                    parameters: ["include_email": "true", "skip_status": "true"],
//                    error: nil)
//
//                client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
//                    if let someData = data {
//                        do {
//                            let results = try JSONSerialization.jsonObject(with: someData, options: .allowFragments) as! NSDictionary
//
//                            let myString = results.object(forKey: "name") as! String;
//                            var myStringArr = myString.components(separatedBy: " ")
//
//                            var profilePicture = results.object(forKey: "profile_image_url") as! String;
//                            profilePicture = profilePicture.replacingOccurrences(of: "_normal", with: "", options: NSString.CompareOptions.literal, range: nil)
//
//                            print(results)
//                            if let responseBlock = self.successBlock {
//
//                                let defaults = UserDefaults.standard
//                                let params: [String: String] = [
//                                    "data[api_key]": DefineMacros.API_KEY,
//                                    "data[User][first_name]": myStringArr[0],
//                                    "data[User][last_name]": myStringArr[1],
//                                    "data[User][twitter_id]": results.object(forKey: "id_str") as! String,
//                                    "data[User][picture]": profilePicture,
//                                    "data[Device][device_type]": "ios",
//                                    "data[Device][device_token]": defaults.object(forKey: DefineMacros.DEVICE_TOKEN) as! String
//                                ]
//
//                                responseBlock(params as AnyObject);
//                            }
//
//                        } catch {
//                        }
//                    }
//                }
//            } else {
//                print("error: \(error!.localizedDescription)");
//            }
//        }
//
//    }

}
