//
//  ViewController.swift
//  MapKit-TravelBook
//
//  Created by Murat on 4.11.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
    }


}

