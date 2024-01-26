//
//  Place.swift
//  FoursquareClone(Parse)
//
//  Created by chvck on 19.01.2024.
//

import Foundation
import UIKit

class Place {
    
    static let sharedInstance = Place()
    
    var placeName = ""
    var placeInfo = ""
    var placeImage =  UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    
    private init(){}
}
