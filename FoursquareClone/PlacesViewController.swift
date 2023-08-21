//
//  PlacesViewController.swift
//  FoursquareClone
//
//  Created by Onur Bulut on 20.08.2023.
//

import UIKit
import Parse

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource

{
 
 var nameArray = [String]()
    var idArray = [String]()
    var selectedPlaceId = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style:  UIBarButtonItem.Style.plain, target: self, action:  #selector(logOutButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getPlaces()
        
        
    }
    @objc func addButtonClicked(){
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
        
    }
    
    @objc func logOutButtonClicked(){
    
        DispatchQueue.main.async {
            PFUser.logOutInBackground { (error) in
                if let error = error {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
                }
            }
        }

        
    }
    
    func getPlaces(){
        self.nameArray.removeAll(keepingCapacity: false)
        self.idArray.removeAll(keepingCapacity: false)
        
        let query = PFQuery(className: "Places")
        
        query.findObjectsInBackground { objects, error in
            
            if error != nil {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else {
                objects?.forEach({ object in
                    if let name = object.object(forKey: "name") as? String {
                        if let id = object.objectId {
                            self.nameArray.append(name)
                            self.idArray.append(id)
                        }
                    }
                })
            }
            self.tableView.reloadData()
            
            
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idArray.count
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        
        alert.addAction(okButton)
        
        present(alert,animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! DetailViewController
            
            destinationVC.chosenPlaceId = selectedPlaceId
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = idArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }

    
}
