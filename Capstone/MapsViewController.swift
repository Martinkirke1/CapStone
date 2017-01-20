//
//  MapsViewController.swift
//  Capstone
//
//  Created by Martin Kirke on 12/8/16.
//  Copyright © 2016 Ghost. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UISearchBarDelegate {
    
    var arrayPin = [MKAnnotation]()
    var DupPin = [MKAnnotation]()
    var cityName = "Maps"
    var stateName = ""
    var countryName = ""
    var stateTextfield: UITextField?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.requestLocation()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        self.RangeSearchBar.delegate = self
        
        RangeSearchBar.placeholder = "City Name, State"
        
        getVenueInfo()
        
        if InternetConnection.isInternetAvailable() == true {
            print("Do Nothing")
        } else {
            let internetAlert = UIAlertController(title: "Could not get venue information", message: "Please make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            internetAlert.addAction(okAction)
            present(internetAlert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var RangeSearchBar: UISearchBar!
    
    
    func getVenueInfo(){
        
        guard let Location = locationManager.location
            else {  return  }
        
        let latitude =  Location.coordinate.latitude
        let longitude = Location.coordinate.longitude
        
        RangeSearchBar.resignFirstResponder()
        
        ConcertController.shared.fetchVenueLocation(lat: latitude, lon: longitude) { (ConcertLocation) in
            
            //self.getInfo()
            
            for venue in ConcertLocation {
                
                let lat = venue.latitude
                let lon = venue.longitude
                let name = venue.name
                let address = venue.address
                let ex_address = venue.extended_address
                self.cityName = venue.city
                self.stateName = venue.state
                
                // let annotationView = MKPinAnnotationView()
                
                let NewPin = MKPointAnnotation()
                NewPin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                NewPin.title = name
                
                if address != "No address info available" {
                    NewPin.subtitle = address
                } else {
                    NewPin.subtitle = ex_address
                }
                
                self.arrayPin.append(NewPin)
                
                
                DispatchQueue.main.async {
                    self.navigationItem.title = "\(self.cityName + ", " + self.stateName)"
                    self.mapView.addAnnotations(self.arrayPin)
                }
            }
        }
    }
    
    
    
    func getInfo(){
        DispatchQueue.main.async {
            let all = self.mapView.annotations
            self.mapView.removeAnnotations(all)
            self.mapView.removeAnnotations(self.arrayPin)
            self.mapView.reloadInputViews()
        }
        self.arrayPin.removeAll()
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard var searchTerm = RangeSearchBar.text else { return }
        RangeSearchBar.resignFirstResponder()
        
        ConcertController.shared.fetchVenueBySearch(searchTerm: searchTerm) { (ConcertLocation) in
            
            self.getInfo()
            
//            if  !searchTerm.contains(", ") || !searchTerm.contains(",") {
//                let alertMap = UIAlertController(title: "No State", message: "Please Enter A State", preferredStyle: .alert)
//                
//
////                alertMap.addTextField(configurationHandler: { (textField) in
////                    textField.placeholder = "Enter State"
////                    guard let searchText = textField.text else { return }
////                   searchTerm = searchText
////                    print(searchTerm)
////                })
//                
//                
////                let textAction = UIAlertAction(title: "Set Text", style: .default) { (_) in
////                    
////                }
////                
//                
////                
////                alertMap.addTextField { ( textField) in
////                    textField = self.stateTextfield
////                }
////
//                
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//               
//                
//                alertMap.addAction(okAction)
//                alertMap.addAction(cancelAction)
//                
//                
//                self.present(alertMap, animated: true, completion: nil)
//                
//            }
            
            
            for venue in ConcertLocation {
                
                let lat = venue.latitude
                let lon = venue.longitude
                let name = venue.name
                let address = venue.address
                let ex_address = venue.extended_address
                self.cityName = venue.city
                self.stateName = venue.state
//                self.countryName = venue.
                
                let annotationView = MKPinAnnotationView()
                
                annotationView.pinTintColor = UIColor.black
                
                let NewPin = MKPointAnnotation()
                NewPin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                NewPin.title = name
                
                if address != "No address info available" {
                    NewPin.subtitle = address
                } else {
                    NewPin.subtitle = ex_address
                }
                
                
                let originalArrayCount = self.arrayPin.count
                
                if originalArrayCount == (self.arrayPin.filter({$0.coordinate.latitude != NewPin.coordinate.latitude && $0.coordinate.longitude != NewPin.coordinate.longitude})).count {
                    // If it gets in here, that means the pin didn't exist
                    self.arrayPin.append(NewPin)
                } else {
                    self.DupPin.append(NewPin)
                }
            }
            print(self.DupPin.count)
            print(self.arrayPin.count)

//            for items in self.arrayPin {
//
//                let noDup = items.coordinate
//                print(noDup)
//            }
            DispatchQueue.main.async {
                let commaText = ", "
                if self.stateName == "no state info available" {
                    self.stateName = ""
                    self.navigationItem.title = "\(self.cityName + self.stateName)"
                } else {
                self.navigationItem.title = "\(self.cityName + commaText + self.stateName)"
                }
                let all = self.mapView.annotations
                self.mapView.removeAnnotations(all)
                
                self.mapView.showAnnotations(self.arrayPin, animated: true)
                self.mapView.reloadInputViews()
                
                
            }
            
        }
        
    }
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = LocationController.sharedController.locationManager
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors" + error.localizedDescription)
    }
    
}

extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let annotationView = MKPinAnnotationView()
//
//        annotationView.pinTintColor = UIColor.blue
//
//        return annotationView
//    }

//
//                func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//                    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "identifier") as? MKPinAnnotationView
//                    if annotationView == nil {
//                        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
//                        annotationView?.canShowCallout = true
//                        annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
//                    } else {
//                        annotationView?.annotation = annotation
//                    }
//
//                    return annotationView
//                }


