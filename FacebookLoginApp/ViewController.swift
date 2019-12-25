//
//  ViewController.swift
//  FacebookLoginApp
//
//  Created by Nan Su on 12/24/19.
//  Copyright © 2019 Nan Su. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {

    @IBOutlet weak var photoImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile], viewController: self, completion: {
            (loginResult: LoginResult) in
            switch loginResult{
            case .failed(let error):
                print(error.localizedDescription)
        
            case .cancelled:
                print("login cancelled")
                
            case .success(granted: _, declined: _, token: _):
                print("success, user was logged in")
                self.getDetails()
            }
        })
    }
    
    func getDetails() {
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "name, picture"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: HTTPMethod.get)

        let connection = GraphRequestConnection()

        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error != nil {
                //do something with error
                print("No Data returned")
            } else {
                //do something with result
                print("Data returned")
                let dictionary = result as? NSDictionary
                let name = dictionary?.object(forKey: "name")
                let picture = dictionary?.object(forKey: "picture")
            }

        })

        connection.start()
    }
    
}

