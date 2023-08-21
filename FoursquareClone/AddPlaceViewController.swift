//
//  AddPlaceViewController.swift
//  FoursquareClone
//
//  Created by Onur Bulut on 20.08.2023.
//

import UIKit

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var placeNameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    
    
    @IBOutlet weak var atmosphereText: UITextField!
    
    @IBOutlet weak var placeImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImageView.addGestureRecognizer(gestureRecognizer)
   
    }
    
    @objc func chooseImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated:  true)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        
        self.dismiss(animated: true)
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if  atmosphereText.text != "" && placeTypeText.text != "" &&  placeNameText.text != ""{
            
            if let image = placeImageView.image{
                let placeModel = PlaceModel.sharedInstance
                placeModel.PlaceAtmosphere = atmosphereText.text ?? ""
                placeModel.PlaceType = placeTypeText.text ?? ""
                placeModel.placeName = placeNameText.text ?? ""
                placeModel.placeImage = placeImageView.image  ?? UIImage()
                
                
                
                
                self.performSegue(withIdentifier: "toMapVC", sender: nil)
                
            }else{
                self.makeAlert(title: "Error", message: "Eksik bilgi")

            }
            
        }else {
            
            self.makeAlert(title: "Error", message: "Eksik bilgi")
        }
        
        
    
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        
        alert.addAction(okButton)
        
        present(alert,animated: true)
    }
    
}
