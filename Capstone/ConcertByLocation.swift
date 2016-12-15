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
    
    //    var locationInfo : [[String: Any]] = []
    
    var city: String
    var name: String
    var extended_address: String
    var address: String
    var state: String
    var latitude: Double
    var longitude: Double
    
    
    init(city: String, name: String, extended_address: String, address: String, state: String, latitude: Double, longitude: Double) {
        self.city = city
        self.name = name
        self.extended_address = extended_address
        self.address = address
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
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
    }
}

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





