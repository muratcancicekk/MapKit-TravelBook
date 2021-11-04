//
//  ViewController.swift
//  MapKit-TravelBook
//
//  Created by Murat on 4.11.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate=self
        
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest // kullanıcının yerini en iyi şekilde tespit etmemize yarar
        locationManager.requestWhenInUseAuthorization()// kullanıcının yer takibini hangi durumlarda yapacağımızı seçtiğimiz yer
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // güncellenen lokasyonları bir dizide tutar
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
}

