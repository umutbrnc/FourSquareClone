//
//  MapViewController.swift
//  FoursquareClone(Parse)
//
//  Created by chvck on 19.01.2024.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnSaveLocation: UIButton!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureLongPress = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gesture:)))
        mapView.addGestureRecognizer(gestureLongPress)
        
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @objc func chooseLocation(gesture : UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizer.State.began{
            let touches = gesture.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = Place.sharedInstance.placeName
            annotation.subtitle = Place.sharedInstance.placeInfo
            self.mapView.addAnnotation(annotation)
            
            Place.sharedInstance.placeLatitude = String(coordinates.latitude)
            Place.sharedInstance.placeLongitude = String(coordinates.longitude)
            
        }
        
        
    }
    
    
    @IBAction func saveLocationClicked(_ sender: Any) {
        
        let place = Place.sharedInstance
        let object = PFObject(className: "Places")
        object["name"] = place.placeName
        object["info"] = place.placeInfo
        object["latitude"] = place.placeLatitude
        object["longitude"] = place.placeLongitude
            
        if let imageData = place.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground{(success,error) in
            if error != nil{
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Undefined error")
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
            
        }//...closure
        
    }//.saveLocationClicked
    
    
    
    func makeAlert( titleInput : String , messageInput : String) {
        let Alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        Alert.addAction (okButton)
        self.present(Alert,animated: true)
    }

}
