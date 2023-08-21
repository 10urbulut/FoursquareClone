//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Onur Bulut on 20.08.2023.
//

import Foundation
import UIKit


class PlaceModel{
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var PlaceType = ""
    var PlaceAtmosphere = ""
    var placeImage = UIImage()
    var latitude = ""
    var longitude = ""
    
    private init(){}
}
