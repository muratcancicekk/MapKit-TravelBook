//
//  ViewController.swift
//  MapKit-TravelBook
//
//  Created by Murat on 4.11.2021.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    var chosenLatiude = Double()
    var chosenLongitude = Double()
    
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate=self
        
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest // kullanıcının yerini en iyi şekilde tespit etmemize yarar
        locationManager.requestWhenInUseAuthorization()// kullanıcının yer takibini hangi durumlarda yapacağımızı seçtiğimiz yer
        locationManager.startUpdatingLocation()
        
        //kullanıcı haritada bir yere uzun süreli tıkladığında pin oluşturuyorum
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecogniner:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        
                                                             
        
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        newPlace.setValue(nameTextField.text, forKey: "title")
        newPlace.setValue(commentTextField.text, forKey: "subtitle")
        newPlace.setValue(chosenLatiude, forKey: "latiude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        
        do{
            try context.save()
            print("success")
        }
        catch{
            print("error")
            
        }
        
        
    }
    
    @objc func chooseLocation(gestureRecogniner: UILongPressGestureRecognizer){
        if gestureRecogniner.state == .began{
            let touchedPoint = gestureRecogniner.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint,toCoordinateFrom:self.mapView)
            
            chosenLatiude=touchedCoordinates.latitude
            chosenLongitude=touchedCoordinates.longitude
            
            let annotation=MKPointAnnotation()
            
            annotation.coordinate=touchedCoordinates
            annotation.title=nameTextField.text
            annotation.subtitle=commentTextField.text
            self.mapView.addAnnotation(annotation)
        }
        
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // güncellenen lokasyonları bir dizide tutar
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
}

