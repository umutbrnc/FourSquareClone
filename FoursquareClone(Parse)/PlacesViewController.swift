//
//  PlacesViewController.swift
//  FoursquareClone(Parse)
//
//  Created by chvck on 19.01.2024.
//

import UIKit
import Parse

let customcolor = UIColor(red: 180, green: 170, blue: 230, alpha: 1)

class PlacesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableViewList: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        tableViewList.delegate = self
        tableViewList.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        getData()

        
    }//...viewdidLoad
    
    
    func getData(){
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground{(objects,error) in
            
            if error != nil{
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Undefined error")
            }else{
                
                if objects != nil{
                    
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    
                    for object in objects!{
     
                        if let placeName = object.object(forKey: "name") as? String{
                            if let placeId = object.objectId{
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }//...for
                    self.tableViewList.reloadData()
                }
   
            }
            

        }//...closure

        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destination = segue.destination as? DetailsViewController
            destination?.chosenPlaceId = selectedPlaceId
        }
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let placeIdToDelete = placeIdArray[indexPath.row]

            // Remove the item from your local arrays
            self.placeIdArray.remove(at: indexPath.row)
            self.placeNameArray.remove(at: indexPath.row)

            // Delete the row from the table view
            tableViewList.deleteRows(at: [indexPath], with: .automatic)

            // Delete the record from Parse
            let query = PFQuery(className: "Places")
            query.getObjectInBackground(withId: placeIdToDelete) { (object, error) in
                if let error = error {
                    self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                } else if let object = object {
                    object.deleteInBackground { (success, error) in
                        if let error = error {
                            self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                        } else if success {
                            self.makeAlert(titleInput: "Deleted", messageInput: "Successfully deleted")
                        }
                    }
                }
            }
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = placeNameArray[indexPath.row]
        cell.backgroundColor = UIColor(red: 180/255, green: 170/255, blue: 230/255 , alpha: 1)
        cell.contentConfiguration = content
        return cell
    }
    
    
    @objc func logout(){
        
        PFUser.logOutInBackground { error in
            if error != nil{
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Undefined error")
            }else{
                self.performSegue(withIdentifier: "toSignVC", sender: nil)
            }
            
        }
        //...closure
        
        
    }//...logout
    
    @objc func addButtonClicked(){
       performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }

    
    func makeAlert( titleInput : String , messageInput : String) {
        let Alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        Alert.addAction (okButton)
        self.present(Alert,animated: true)
    }

    

}
