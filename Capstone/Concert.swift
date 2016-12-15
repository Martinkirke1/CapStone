//
//  Concert.swift
//  Capstone
//
//  Created by Martin Kirke on 12/8/16.
//  Copyright © 2016 Ghost. All rights reserved.
//

import Foundation

class Concert {
    
    
    private let Kname = "title"
    private let Kurl = "url"
    
    private let Kperformer = "performers"
    private let Kperformer_name = "name"
    private let Kperformer_url = "url"
    private let Kimage = "image"
    
    private let Kvenue = "venue"
    private let Kcity = "city"
    private let KvenueName = "name"
    private let Kaddress = "address"
    private let Kcountry = "country"
    private let Kstate = "state"
    private let Kscore = "score"
    private let Kpostal_code = "postal_code"
    private let Klocation = "location"
    private let Klat = "lat"
    private let Klon = "lon"
    private let Kid = "id"
    
    
    let title: String
    let url: String
    
    // performers dictionary
//    let performer_name: String
//    let performer_url: String
//    let image: String
    
    var arrayPerformer: [String] = []
    
    // venue dictionary
    let city: String
    let name: String
    let address: String
    let country: String
    let state: String
    let score : Double
    let postal_code: String
    let lat: Double
    let lon: Double
    let id : Double
    
    
    
    init(title: String, url: String, /* performer_name: String, performer_url: String, image: String, */ city: String, name: String, address: String, country: String, state: String, score: Double, postal_code: String, lat: Double, lon: Double, id: Double, arrayPerformer: [String]) {
        
        self.title = title
        self.url = url
//        self.performer_name = performer_name
//        self.performer_url = performer_url
//        self.image = image
        self.city = city
        self.name = name
        self.address = address
        self.country = country
        self.state = state
        self.score = score
        self.postal_code = postal_code
        self.lat = lat
        self.lon = lon
        self.id = id
        self.arrayPerformer = arrayPerformer
    }
    
    
    
    init?(JsonDict: [String: Any]) {
        
        
        
        guard let title = JsonDict[Kname] as? String,
            let url = JsonDict[Kurl] as? String,
            let preformerDict = JsonDict[Kperformer] as? [[String: Any]] else { return nil }
        
        
        for performer in preformerDict {
            guard let performer_name = performer[Kperformer_name] as? String,
                let performer_url = performer[Kperformer_url] as? String,
                let image = performer[Kimage] as? String
                else { return nil }
            arrayPerformer.append(performer_name)
            arrayPerformer.append(performer_url)
            arrayPerformer.append(image)
        }
        
        
        
        guard let venueDict = JsonDict[Kvenue] as? [String : Any],
            let city = venueDict[Kcity] as? String,
            let name = venueDict[KvenueName] as? String,
            let address = venueDict[Kaddress] as? String,
            let country = venueDict[Kcountry] as? String,
            let state = venueDict[Kstate] as? String,
            let score = venueDict[Kscore] as? Double,
            let postal_code = venueDict[Kpostal_code] as? String,
            let locationDict = venueDict[Klocation] as? [String : Any],
            let latitude = locationDict[Klat] as? Double,
            let longitude = locationDict[Klon] as? Double,
            let id = venueDict[Kid] as? Double
            
            else { return nil }
        
        self.title = title
        self.url = url
        self.city = city
        self.name = name
        self.address = address
        self.country = country
        self.state = state
        self.score = score
        self.postal_code = postal_code
        self.lat = latitude
        self.lon = longitude
        self.id = id
    }
    
}
