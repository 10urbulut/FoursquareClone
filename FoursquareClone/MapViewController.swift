//
//  MapViewController.swift
//  FoursquareClone
//
//  Created by Onur Bulut on 20.08.2023.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    let placeModel = PlaceModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style:  UIBarButtonItem.Style.plain, target: self, action:  #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style:  UIBarButtonItem.Style.plain, target: self, action:  #selector(backButtonClicked))
        
        
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
        
    }
    
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            
            let touches = gestureRecognizer.location(in: self.mapView)
            
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.PlaceType
            
            self.mapView.addAnnotation(annotation)
            
            placeModel.latitude = String(coordinates.latitude)
            placeModel.longitude = String(coordinates.longitude)
        }
    }
    

    @objc func saveButtonClicked(){
   
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.PlaceType
        object["atmosphere"] = placeModel.PlaceAtmosphere
        object["latitude"] = placeModel.latitude
        object["longitude"] = placeModel.longitude
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "\(placeModel.PlaceType).jpg", data: imageData)
        }
        
        object.saveInBackground { success, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
            
     
        
    }
    
    @objc func backButtonClicked(){
        
        self.dismiss(animated: true)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        
        alert.addAction(okButton)
        
        present(alert,animated: true)
    }
    

}
