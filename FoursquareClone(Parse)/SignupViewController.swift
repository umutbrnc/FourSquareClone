//
//  SignUpViewController.swift
//  FoursquareClone(Parse)
//
//  Created by chvck on 19.01.2024.
//

import UIKit
import Parse

class SignupViewController: UIViewController {

    
    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var lblConfirmPassword: UITextField!
    @IBOutlet weak var switchAgree: UISwitch!
    @IBOutlet weak var lblAlreadyHave: UILabel!
    @IBOutlet weak var btnSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        btnSignup.isEnabled=false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goPage))
        let keyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        lblAlreadyHave.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(keyboardGesture)
       
        
        
        
        
        
    }
    
    
    
    
    @IBAction func switchChanged(_ sender: Any) {
        if switchAgree.isOn{
            btnSignup.isEnabled=true
        }else{
            btnSignup.isEnabled=false
        }
        
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        
        if lblUsername.text == ""{
            makeAlert(titleInput: "Fill the blanks!", messageInput: "Username does not exist")
        }else if lblPassword.text == ""{
            makeAlert(titleInput: "Fill the blanks!", messageInput: "Password does not exist")
        }else if lblConfirmPassword.text == ""{
            makeAlert(titleInput: "Fill the blanks!", messageInput: "Confirm Password does not exist")
        }else if lblPassword.text != lblConfirmPassword.text{
            makeAlert(titleInput: "Error!", messageInput: "Passwords don't match")
        }else{
            
            let user = PFUser()
            user.username = lblUsername.text!
            user.password = lblPassword.text!
            

            user.signUpInBackground { (success, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Undefined error")
                }else{
                    self.performSegue(withIdentifier: "toLoginVC", sender: nil)
                }
 
                
            }
           

        }
        
       
        
        
    }//...signUpClicked
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toLoginVC"{
           let destinationVC = segue.destination as? LoginViewController
           destinationVC?.signedUpSuccess = true
       }
      
        
    }

    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func goPage(){
        performSegue(withIdentifier: "toLogin2VC", sender: nil)
    }
    
    
    func makeAlert( titleInput : String , messageInput : String) {
        let Alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        Alert.addAction (okButton)
        self.present(Alert,animated: true)
    }

    
    
    
    
    
    
    
    
}
