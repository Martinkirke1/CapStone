//
//  ConcertByLocation.swift
//  Capstone
//
//  Created by Martin Kirke on 12/9/16.
//  Copyright © 2016 Ghost. All rights reserved.
//

import Foundation

class ConcertByLocation {
    
    private let Kcity = "city"
    private let Kname = "name"
    private let Kextended_address = "extended_address"
    private let Kaddress = "address"
    private let Kstate = "state"
    private let Kpostal = "postal"
    private let Klatitude = "lat"
    private let Klongitude = "lon"
    private let Klocation = "location"
    private let Kid = "id"
    private let Kurl = "url"
    private let kScore = "score"
    
    //var locationInfo : [[String: Any]] = []
    
    var city: String
    var name: String
    var extended_address: String
    var address: String
    var state: String
    var latitude: Double
    var longitude: Double
    var url: String
    var score: Double
    //Geolocation Dictionary
//    let geoCity: String
//    let display_name: String
//    let country: String
//    let lon: Double
//    let lat: Double
//    let geoState: String
//    
//    init(geoCity: String, display_name: String, country: String, lon: Double, lat: Double, geoState: String ) {
//        self.geoCity = geoCity
//        self.display_name = display_name
//        self.country = country
//        self.lon = lon
//        self.lat = lat
//        self.geoState = geoState
//    }
    
    
    init(city: String, name: String, extended_address: String, address: String, state: String, latitude: Double, longitude: Double, url: String, score: Double) {
        self.city = city
        self.name = name
        self.extended_address = extended_address
        self.address = address
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
        self.score = score
    }
    
    
    
    init?(JsonDict: [String : Any]) {
        
        
        guard let city = JsonDict[Kcity] as? String,
            let locationDict = JsonDict[Klocation] as? [String : Any],
            let latitude = locationDict[Klatitude] as? Double,
            let longitude = locationDict[Klongitude] as? Double
            else {
                return nil
        }
        
        self.city = city
        self.name = JsonDict[Kname] as? String ?? "no name info available"
        self.extended_address = JsonDict[Kextended_address] as? String ?? "No ex_address info available"
        self.address = JsonDict[Kaddress] as? String ?? "No address info available"
        self.state = JsonDict[Kstate] as? String ?? "no state info available"
        self.latitude = latitude
        self.longitude = longitude
        self.url = JsonDict[Kurl] as? String ?? "no url info available"
        self.score = JsonDict[kScore] as? Double ?? 0
    }
}


// GeoLocation
//extension ConcertByLocation {
//    
//    
//    convenience init?(locationDict :[String:Any]) {
//        guard let geoCity = locationDict["city"],
//        let display_name = locationDict["display_name"],
//        let country = locationDict["country"],
//        let lon = locationDict["lon"],
//        let lat = locationDict["lat"],
//        let geoState = locationDict["geoState"]
//        
//    }
    
    
    
    
    
    
    
    


//            var locationDic : [String:Any] = [:]
//
//            locationDic[Kcity] = city as String
//            locationDic[Kname] = name as String
//            locationDic[Kextended_address] = extended_address as String
//            locationDic[Kaddress] = address as String
//            locationDic[Kstate] = state as String
//            locationDic[Klatitude] = latitude as Double
//            locationDic[Klongitude] = longitude as Double
//            locationInfo.append(locationDic)
//
//            locationInfo.append(name)
//            locationInfo.append(city)
//            locationInfo.append(extended_address)
//            locationInfo.append(address)
//            locationInfo.append(state)





