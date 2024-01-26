//
//  DetailsViewController.swift
//  FoursquareClone(Parse)
//
//  Created by chvck on 19.01.2024.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController, MKMapViewDelegate {

    
    
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var mapDetail: MKMapView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        getDataFromParse()
        mapDetail.delegate = self
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(goBack))
       
        
    }
    
    
    @objc func goBack(){
        
        self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
        
    }
    
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground{(objects,error) in
            if error != nil{
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Undefined error")
            }else{
                
                if objects != nil{
                    if objects!.count > 0{
                        
                        let chosenPlaceObject = objects![0]
                        
                        
                        //object
                        
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                            self.lblDetail.text = placeName
                        }
                        if let placeInfo = chosenPlaceObject.object(forKey: "info") as? String{
                            self.lblInfo.text = placeInfo
                        }
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude){
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject{
                            imageData.getDataInBackground{(data,error) in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Undefined error")
                                }else{
                                    if data != nil{
                                        self.imgDetail.image = UIImage(data: data!)
                                    }
                                        
                                }
                            }
                        }
                        
                        
                        //maps
                        
                        
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.mapDetail.setRegion(region, animated: true)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.lblDetail.text
                        annotation.subtitle = self.lblInfo.text
                        self.mapDetail.addAnnotation(annotation)
                        
                    }
                }
            }
            
        }//...closure
  
    }
    
    
    
    

    func makeAlert( titleInput : String , messageInput : String) {
        let Alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        Alert.addAction (okButton)
        self.present(Alert,animated: true)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseid = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
        
        if pinView == nil{
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0{
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks{
                    if placemark.count > 0{
                        let mkPlaceMark = MKPlacemark(placemark:placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.lblDetail.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
        
    }
   


}
