////
////  enterLocationForConcert.swift
////  Capstone
////
////  Created by Martin Kirke on 12/14/16.
////  Copyright © 2016 Ghost. All rights reserved.
////
//
//import Foundation
//
//class enterLocationForConcerts {
//    
//    
//    //within events array of dictionary
//    let title: String
//    let type: String
//    
//    // within venue dictionary
//    
//    let city: String
//    let name: String
//    let state: String
//    let venueScore: Double
//    let address: String
//    
//    
//    // within location dictionary, wihtin venue dictionary
//    
//    var latitude: Double
//    var longitude: Double
//    
//    init(title: String, type: String, city: String, name: String,  state: String, venueScore: Double, address: String, latitude: Double, longitude: Double) {
//        
//        self.title = title
//        self.type = type
//        self.city = city
//        self.name = name
//        self.state = state
//        self.venueScore = venueScore
//        self.address = address
//        self.latitude = latitude
//        self.longitude = longitude
//    }
//    
//    init?(jsonDict: [String:Any]) {
//        
//        guard let title = jsonDict["title"] as? String,
//            let type = jsonDict["type"] as? String,
//            let venueDict = jsonDict["venue"] as? [String:Any],
//            let city = venueDict["city"] as? String,
//            let name = venueDict["name"] as? String,
//            let state = venueDict["state"] as? String,
//            let venueScore = venueDict["score"] as? Double,
//            let address = venueDict["address"] as? String,
//            let locationDict = venueDict["location"] as? [String:Any],
//            let latitude = locationDict["lat"] as? Double,
//            let longitude = locationDict["lon"] as? Double
//            else { return nil }
//        
//        self.title = title
//        self.type = type
//        self.city = city
//        self.name = name
//        self.state = state
//        self.venueScore = venueScore
//        self.address = address
//        self.latitude = latitude
//        self.longitude = longitude
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}
