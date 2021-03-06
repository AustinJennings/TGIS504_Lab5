//
//  ViewController.swift
//  504Lab5q1
//
//  Created by Austin Jennings on 3/10/18.
//  Copyright © 2018 Austin Jennings. All rights reserved.
//

import UIKit
import MapKit

let locManager = CLLocationManager()

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMapView.delegate = self
        myMapView.showsUserLocation = true
        myMapView.showsCompass = true
        myMapView.isZoomEnabled = true
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
        }
        let sourceCoord = locManager.location?.coordinate
        let destCoord = CLLocationCoordinate2DMake(47.2446, -122.4376)
        
        let sourcePlaceMk = MKPlacemark(coordinate: sourceCoord!)
        let destPlaceMk = MKPlacemark(coordinate: destCoord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMk)
        let destItem = MKMapItem(placemark: destPlaceMk)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
                response, error in
                guard let response = response else {
                    if error != nil {
                            print("Oops, Something went wrong.")
                        }
                        return
                    }
            let route = response.routes[0]
            self.myMapView.add(route.polyline, level: .aboveRoads)

            })

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

