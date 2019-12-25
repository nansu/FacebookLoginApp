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
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "name, picture.width(640).height(480)"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: HTTPMethod.get)

        let connection = GraphRequestConnection()

        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error != nil {
                //do something with error
                print("No Data returned")
            } else {
                //do something with result
                print("Data returned")
                
                /*
                 data format
                 ["id": 123, "name": "nsu",
                 "picture": {
                    data = {
                        url = "http://www.facebook.com/myprofileimage";
                        height = 50;
                        width = 50;
                    }
                 }]
                 */
                
                guard let responseDictionary = result as? NSDictionary else { return }
                
                let name = responseDictionary["name"] as? String
                self.nameLabel.text = name
                
                guard let picture = responseDictionary["picture"] as? NSDictionary else { return }
                
                guard let data = picture["data"] as? NSDictionary else { return }
                
                guard let urlString = data["url"] as? String else { return }
                
                guard let url = URL(string: urlString) else { return }
                DispatchQueue.global().async {
                    guard let data = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.photoImgView.image = image
                    }
                }
                
                
            }

        })

        connection.start()
    }
    
}

