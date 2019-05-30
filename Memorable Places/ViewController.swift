//
//  ViewController.swift
//  Memorable Places
//
//  Created by Mahieu Bayon on 15/06/2018.
//  Copyright © 2018 M4m0ut. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
        if activePlace == -1 {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()

        } else {
            
            let placesObject = UserDefaults.standard.object(forKey: "places")
            
            if let tempPlaces = placesObject as? [Dictionary<String, String>] {
                
                if tempPlaces.count > activePlace {
                    
                    if let name = tempPlaces[activePlace]["name"] {
                        
                        if let lat = tempPlaces[activePlace]["lat"] {
                            
                            if let lon = tempPlaces[activePlace]["lon"] {
                                
                                if let latitude = Double(lat) {
                                    
                                    if let longitude = Double(lon) {
                                        
                                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                        
                                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        
                                        let region = MKCoordinateRegion(center: coordinate, span: span)
                                        
                                        self.map.setRegion(region, animated: true)
                                        
                                        let annotation = MKPointAnnotation()
                                        
                                        annotation.coordinate = coordinate
                                        
                                        annotation.title = name
                                        
                                        self.map.addAnnotation(annotation)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
         
            let touchPoint = gestureRecognizer.location(in: self.map)
            
            let coordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            
            map.addAnnotation(annotation)
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            print(location)
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    
                    var name: String = ""

                    if let placemark = placemarks?[0] {
                        
                        if placemark.name != nil {
                            
                            name = placemark.name!
                        }
                        
                        annotation.title = name
                        self.savePlace(name, String(coordinate.latitude), String(coordinate.longitude))
                    }
                }
            }
        }
    }
    
    func savePlace(_ name: String, _ latitude: String, _ longitude: String) {
        let placesObject = UserDefaults.standard.object(forKey: "places")
        
        var places = [Dictionary<String, String>()]
        
        if let tempPlaces = placesObject as? [Dictionary<String, String>] {
            
            places = tempPlaces
            
            places.append(["name": name, "lat": latitude, "lon": longitude])
            
            print(places)
            
        } else {
            
            places.append(["name": name, "lat": latitude, "lon": longitude])

        }
        
        UserDefaults.standard.set(places, forKey: "places")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

