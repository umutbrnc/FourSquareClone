//
//  AddPlaceViewController.swift
//  FoursquareClone(Parse)
//
//  Created by chvck on 19.01.2024.
//

import UIKit
import MapKit

class AddPlaceViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtInfo: UITextView!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        btnNext.isEnabled = false
        
        let keyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(keyboardGesture)
        
        imgSelect.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imgSelect.addGestureRecognizer(tapGesture)
        
        
    }
 
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if txtName.text == ""{
            makeAlert(titleInput: "Fill the Blanks!", messageInput: "Place name does not exist")
        }else if txtInfo.text == ""{
            makeAlert(titleInput: "fill the Blanks!", messageInput: "Place information does not exist")
        }else{
            let place = Place.sharedInstance
            place.placeName = txtName.text!
            place.placeInfo = txtInfo.text!
            if let chosenImage = imgSelect.image{
                place.placeImage = chosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }
        
        
    }
    
    
    
    @objc func selectImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true)

        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgSelect.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
        btnNext.isEnabled = true
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    
    func makeAlert( titleInput : String , messageInput : String) {
        let Alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        Alert.addAction (okButton)
        self.present(Alert,animated: true)
    }

}
