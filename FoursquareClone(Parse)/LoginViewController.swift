//
//  ViewController.swift
//  FoursquareClone(Parse)
//
//  Created by chvck on 19.01.2024.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    
    
    var signedUpSuccess = false
    
    override func viewWillAppear(_ animated: Bool) {
        if signedUpSuccess == true{
            makeAlert(titleInput: "Success", messageInput: "Signed up successfully!")
            signedUpSuccess = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        let keyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(keyboardGesture)
       
    }//...viewDidLoad

    
    @IBAction func loginClicked(_ sender: Any) {
        
        if lblUsername.text == ""{
            makeAlert(titleInput: "Fill the blanks!", messageInput: "Username does not exist")
        }else if lblPassword.text == ""{
            makeAlert(titleInput: "Fill the blanks!", messageInput: "Password does not exist")
        }else{
            
            //sign in
            PFUser.logInWithUsername(inBackground: lblUsername.text!, password: lblPassword.text!) { (user, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Undefined error")
                }else{
                    
                    print("welcome")
                    print(user?.username)
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                    
                    
                }
                
            }//...closure
            
      
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignupVC", sender: nil)
    }
    
    
    func makeAlert( titleInput : String , messageInput : String) {
        let Alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        Alert.addAction (okButton)
        self.present(Alert,animated: true)
    }

    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    
}

