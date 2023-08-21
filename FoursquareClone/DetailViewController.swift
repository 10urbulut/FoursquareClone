//
//  DetailViewController.swift
//  FoursquareClone
//
//  Created by Onur Bulut on 20.08.2023.
//

import UIKit
import MapKit
import Parse

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    @IBOutlet weak var placeAtmosphereLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenPlaceLatitude = Double()
    var chosenPlaceLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getData()

        

    }
    


    func getData(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else {
                if let  object = objects?.first{
                    
                    
                    
                    self.placeNameLabel.text = object.object(forKey: "name") as? String
                    self.placeTypeLabel.text = object.object(forKey: "type") as? String
                    self.placeAtmosphereLabel.text = object.object(forKey: "atmosphere") as? String
                   
                    
                    if let placeLatitude =  object.object(forKey: "latitude") as? String{
                        self.chosenPlaceLatitude = Double(placeLatitude) ?? 0
                        
                    }
                    
                    if let placeLongitude = object.object(forKey: "longitude") as? String{
                        self.chosenPlaceLongitude = Double(placeLongitude) ?? 0
                        
                        
                    }
                    
                    if let imageData = object.object(forKey: "image") as? PFFileObject{
                        
                        imageData.getDataInBackground { data, error in
                            if error == nil {
                                
                                if data != nil{
                                    self.imageView.image = UIImage(data: data!)
                                }
                             
                            }
                      
                        }
                    }
                    
                    let location = CLLocationCoordinate2D(latitude: self.chosenPlaceLatitude, longitude: self.chosenPlaceLongitude)
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                    
                    let region = MKCoordinateRegion(center: location, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.placeNameLabel.text
                    annotation.subtitle = self.placeTypeLabel.text
                    
                    self.mapView.addAnnotation(annotation)
                    
                    
                }
            }
        }
    }
    
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        
        alert.addAction(okButton)
        
        present(alert,animated: true)
    }
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView?.canShowCallout = true
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            
            pinView?.rightCalloutAccessoryView = button
            
        }else {
            
            pinView?.annotation = annotation
            
        }
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenPlaceLongitude != 0.0 && self.chosenPlaceLatitude != 0.0{
            
            let requestLocation = CLLocation(latitude: chosenPlaceLatitude, longitude: chosenPlaceLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placeMarks, error in
                if let placemark = placeMarks {
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                       
                        let launchOptiıons = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.name = self.placeNameLabel.text
                        mapItem.openInMaps(launchOptions: launchOptiıons)
                    }
                }
            }
        }
    }
}
