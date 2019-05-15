//
//  ViewController.swift
//  Trueu
//
//  Created by Ayub Ali on 2019-05-13.
//  Copyright © 2019 Ayub Ali. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //variables
    
    
    //Constants
    let userDefault = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "usersignedin"){
            performSegue(withIdentifier: "goToSignedIn", sender: self)
        }
    }
    
    //    Mark: Func create user.
    func createUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                //User created
                print("User Created")
                //Sign in user func call.
                self.signInUser(email: email, password: password)
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    //    Mark: Func for signing user.
    func signInUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                //Signed in
                print("User Signed In")
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "goToSignedIn", sender: self)
            }else if (error?._code == AuthErrorCode.userNotFound.rawValue) {
                self.createUser(email: email, password: password)
            }else {
                print(error)
                print(error?.localizedDescription)
            }
        }
    }
    
    //Actions

    @IBAction func signinBtnPressed(_ sender: UIButton) {
        //Guard statements to make sure text is safe and not forced unwrapped
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        //sign in func call.
        signInUser(email: email, password: password)
    }
}

