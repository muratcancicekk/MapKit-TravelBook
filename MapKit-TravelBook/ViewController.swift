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
    var selectedTitle = ""
    var selectedId = UUID()
    var annotationTitle = ""
    var annotationSubTitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    
    
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
        
        if selectedTitle != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let idString = selectedId.uuidString
            
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            fetchReq.returnsObjectsAsFaults = false
            fetchReq.predicate = NSPredicate(format: "id = %@",  idString)
            do{
                let results = try context.fetch(fetchReq)
                if results.count > 0{
                    
                    
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "title") as? String{
                            annotationTitle=title
                            if let subtitle = result.value(forKey: "subtitle") as? String{
                                annotationSubTitle=subtitle
                                if let latiude = result.value(forKey: "latiude") as? Double{
                                    annotationLatitude=latiude
                                    if let longitude = result.value(forKey: "longitude") as? Double{
                                        annotationLongitude=longitude
                                        
                                        
                                        let annotation = MKPointAnnotation()
                                        annotation.title=annotationTitle
                                        annotation.subtitle=annotationSubTitle
                                        let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                        annotation.coordinate=coordinate
                                        
                                        mapView.addAnnotation(annotation)
                                        nameTextField.text = annotationTitle
                                        commentTextField.text = annotationSubTitle
                                        
                                        
                                        locationManager.stopUpdatingLocation()
                                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                        let region = MKCoordinateRegion(center: coordinate, span: span)
                                        mapView.setRegion(region, animated: true )
                                        
                                    }
                                }
                            }
                            
                        }
                        
                        
                        
                        
                    }
                }
            } catch{
                print("error")
            }
            
            
            
            
        }
        else {
            
        }
        
        
        
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
        
        NotificationCenter.default.post(name: NSNotification.Name("NewPlace"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
        
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           
           if annotation is MKUserLocation {
               return nil
           }
           
           let reuseId = "myAnnotation"
           var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
           
           if pinView == nil {
               pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
               pinView?.canShowCallout = true
               pinView?.tintColor = UIColor.black
               
               let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
               pinView?.rightCalloutAccessoryView = button
               
           } else {
               pinView?.annotation = annotation
           }
           
           
           
           return pinView
       }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // güncellenen lokasyonları bir dizide tutar
        
        if selectedTitle == ""{
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
        else {
            
        }
    }
    
    
    
}

