//
//  ConcertController.swift
//  Capstone
//
//  Created by Martin Kirke on 12/8/16.
//  Copyright © 2016 Ghost. All rights reserved.
//

import Foundation
import UIKit


class ConcertController {
    
    static var shared = ConcertController()
    
    let baseURL = "https://api.seatgeek.com/2"
    let apikey = "&client_id=NjM4MjU3NnwxNDgxMjE5MTk4"
    
    
    //==================================================
    // MARK: - Seat Geek API
    //==================================================
    
    func fetchConcertInformation(for SearchTerm: String, completion: @escaping (Concert?) -> Void) {
        
        
        let searchUrl = URL(string:"\(baseURL + "/events?q=" + SearchTerm + "&client_id=NjM4MjU3NnwxNDgxMjE5MTk4")")
        
        guard let url = searchUrl else { return }
        
        NetworkController.performRequest(for: url, httpMethod: .Get) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion(nil)
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] else {
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion(nil)
                return
            }
            
            guard let concert = Concert(JsonDict: jsonDictionary) else { return }
            completion(concert)
            
        }
    }
    
    func artistBySearchTerm(searchTerm: String, completion: @escaping ([Performers]) -> Void){
        
        let searchUrl = "https://api.seatgeek.com/2/performers"
        let parameters = ["q": searchTerm, "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4"]
        
        guard let passedLocationUrl = URL(string: searchUrl) else { return }

        
        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion([])
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any], let venueArray = jsonDictionary["performers"] as? [[String:Any]] else {
                
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion([])
                return
            }
            
            var concertArray: [Performers] = []
            
            //            guard let geoLocation = ConcertByLocation
            
            for dict in venueArray {
                guard let concert =  Performers(JsonDict: dict) else { return }
                concertArray.append(concert)
            }
            
            completion(concertArray)
        }
    }
    
    func fetchVenueLocation(lat: Double, lon: Double, completion: @escaping ([ConcertByLocation]) -> Void) {
        
        let locationUrl  = "https://api.seatgeek.com/2/venues"
        
        let parameters: [String: String] = ["geoip": "true", "lat": "\(lat)", "lon": "\(lon)", "range": "10mi", "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4", "per_page":"100"]
        
        guard let passedLocationUrl = URL(string: locationUrl) else { return }
        
        
        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion([])
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any], let venueArray = jsonDictionary["venues"] as? [[String:Any]] else {
                
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion([])
                return
            }
            
            var concertArray: [ConcertByLocation] = []
            
            //            guard let geoLocation = ConcertByLocation
            
            for dict in venueArray {
                guard let concert =  ConcertByLocation(JsonDict: dict) else { return }
                concertArray.append(concert)
            }
            
            completion(concertArray)
        }
    }
    
    
    func fetchVenueBySearch(searchTerm: String, completion: @escaping ([ConcertByLocation]) -> Void) {
        var state = ""
        var city = ""
        
        var parameters = [String:String]()
        
        if searchTerm.contains(", ") {
            let words = searchTerm.components(separatedBy: ", ")
            city = words[0]
            state = words[1]
            
        } else if searchTerm.contains(",") {
            let words = searchTerm.components(separatedBy: ",")
            city = words[0]
            state = words[1]
        }
        
        
        let locationUrl  = "https://api.seatgeek.com/2/venues"
        if state != "" {
            parameters = ["city" : "\(city)", "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4", "per_page":"50", "state": "\(state)"]
            state = ""
            city = ""
        }
        else {
            parameters = ["city" : "\(searchTerm)", "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4", "per_page":"50"]
            
        }
        
        guard let passedLocationUrl = URL(string: locationUrl) else { return }
        
        
        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion([])
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any], let venueArray = jsonDictionary["venues"] as? [[String:Any]] else {
                
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion([])
                return
            }
            
            var concertArray: [ConcertByLocation] = []
            
            for dict in venueArray {
                guard let concert =  ConcertByLocation(JsonDict: dict) else { return }
                concertArray.append(concert)
            }
            
            completion(concertArray)
        }
    }
    
    func fetchVenueBySearchAndLocation(searchTerm: String, completion: @escaping ([ConcertByLocation]) -> Void) {
        var state = ""
        var city = ""
        
        var parameters = [String:String]()
        
        if searchTerm.contains(", ") {
            let words = searchTerm.components(separatedBy: ", ")
            city = words[0]
            state = words[1]
            
        } else if searchTerm.contains(",") {
            let words = searchTerm.components(separatedBy: ",")
            city = words[0]
            state = words[1]
        }
        
        
        let locationUrl  = "https://api.seatgeek.com/2/venues"
        if state != "" {
            parameters = ["city" : "\(city)", "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4", "per_page":"50", "state": "\(state)"]
            state = ""
            city = ""
        } else {
            parameters = ["city" : "\(searchTerm)", "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4", "per_page":"50"]
            
        }
        
        guard let passedLocationUrl = URL(string: locationUrl) else { return }
        
        
        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion([])
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any], let venueArray = jsonDictionary["venues"] as? [[String:Any]], let geoDict = jsonDictionary["geolocation"]  as? [String:Any] else {
                
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion([])
                return
            }
            
            var concertArray: [ConcertByLocation] = []
            
            for dict in venueArray {
                guard let concert =  ConcertByLocation(JsonDict: dict) else { return }
                concertArray.append(concert)
            }
            
            completion(concertArray)
        }
    }
    
    
    func fetchVenueNameBySearchTerm(searchTerm: String, completion: @escaping ([ConcertByLocation]) -> Void) {
        
        let venueURL = "https://api.seatgeek.com/2/venues"
        let parameters = ["q": searchTerm, "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4"]
        guard let passedLocationUrl = URL(string: venueURL) else { return }
        
        
        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion([])
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any], let venueArray = jsonDictionary["venues"] as? [[String:Any]] else {
                
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion([])
                return
            }
            
            var concertArray: [ConcertByLocation] = []
            
            for dict in venueArray {
                guard let concert =  ConcertByLocation(JsonDict: dict) else { return }
                concertArray.append(concert)
            }
            
            completion(concertArray)
        }
    }
    
    
    func fetchTopVenues(completion: @escaping ([ConcertByLocation]) -> Void) {
        
        let venueURL = "https://api.seatgeek.com/2/venues"
        let parameters = ["sort": "score.desc", "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4"]
        guard let passedLocationUrl = URL(string: venueURL) else { return }
        
        
        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion([])
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any], let venueArray = jsonDictionary["venues"] as? [[String:Any]] else {
                
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion([])
                return
            }
            
            var concertArray: [ConcertByLocation] = []
            
            for dict in venueArray {
                guard let concert =  ConcertByLocation(JsonDict: dict) else { return }
                concertArray.append(concert)
            }
            
            completion(concertArray)
        }
    }
    
    
    //==================================================
    // MARK: - Last.FM API
    //==================================================
    
    func artistBySearchTermAPI(searchTerm: String, completion: @escaping ([Performers]) -> Void){
        
        let searchUrl = "http://ws.audioscrobbler.com/2.0/?"
        let parameters = ["method": "artist.search", "artist": searchTerm, "api_key": "e2b23243d79d3360fdfaf82d0ff99c6d", "format": "json"]
        
        guard let passedLocationUrl = URL(string: searchUrl) else { return }
        
        
        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion([])
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else {
                
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion([])
                return
            }
            
            guard let nameDict = jsonDictionary["results"] as? [String:Any],
            let artistDict = nameDict["artistmatches"] as? [String:Any],
                let artist = artistDict["artist"] as? [[String:Any]] else { return }
            
            var artistArray: [Performers] = []
            
            for artistDict in artist {
                
                guard let artist = Performers(JsonDict: jsonDictionary) else { return }
                artistArray.append(artist)
                
            }
            
            completion(artist)
        }
    }
    //http://ws.audioscrobbler.com/2.0/?method=geo.gettopartists&country=united%20states&api_key=e2b23243d79d3360fdfaf82d0ff99c6d&format=json
    
    func topArtistbyCountry(Country: String, completion: @escaping (topArtistByCountry?) -> Void){
        
        let searchUrl = "http://ws.audioscrobbler.com/2.0/?"
        let parameters = ["method": "geo.gettopartists", "country": Country, "api_key": "e2b23243d79d3360fdfaf82d0ff99c6d", "format": "json"]
        
        guard let passedLocationUrl = URL(string: searchUrl) else { return }
        
        
        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
            
            // check for any errors
            if let error = error {
                NSLog(error.localizedDescription)
                completion(nil)
            }
            
            // make sure we got data
            guard let data = data,
                let responseData = String(data: data, encoding: .utf8) else {
                    print("Error: did not receive data")
                    return
            }
            
            // parse the result as JSON
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else {
                
                NSLog("Unable to serialize JSON.  Response: \(responseData)")
                completion(nil)
                return
            }
            
            guard let artist = topArtistByCountry(JsonDict: jsonDictionary) else { return }
            completion(artist)
        }
    }
    
    
    
    
    
}




//    func fetchConcertLocation(lat: Double, lon: Double, completion: @escaping (ConcertByLocation?) -> Void) {
//
//        let locationUrl  = "https://api.seatgeek.com/2/venues"
//
//        let parameters: [String: String] = ["geoip": "true", "lat": "\(lat)", "lon": "\(lon)", "range": "100mi", "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4", "per_page":"200"]
//
//        guard let passedLocationUrl = URL(string: locationUrl) else { return }
//
//        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
//
//            // check for any errors
//            if let error = error {
//                NSLog(error.localizedDescription)
//                completion(nil)
//            }
//
//            // make sure we got data
//            guard let data = data,
//                let responseData = String(data: data, encoding: .utf8) else {
//                    print("Error: did not receive data")
//                    return
//            }
//
//            // parse the result as JSON
//            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else {
//
//                NSLog("Unable to serialize JSON.  Response: \(responseData)")
//                completion(nil)
//                return
//            }
//
//
//
//            guard let concert = ConcertByLocation(JsonDict: jsonDictionary) else { return }
//            completion(concert)
//        }
//    }
//}



//    func enterLocationForConcert(searchTerm: String, completion: @escaping ([enterLocationForConcerts]) -> Void) {
//
//        let locationUrl  = "https://api.seatgeek.com/2/events?"
//
//        let parameters: [String: String] = ["venue.city": "\(searchTerm)", "client_id": "NjM4MjU3NnwxNDgxMjE5MTk4", "per_page":"100"]
//
//        guard let passedLocationUrl = URL(string: locationUrl) else { return }
//
//
//        NetworkController.performRequest(for: passedLocationUrl, httpMethod: .Get, urlParameters: parameters) { (data, error) in
//
//            // check for any errors
//            if let error = error {
//                NSLog(error.localizedDescription)
//                completion([])
//            }
//
//            // make sure we got data
//            guard let data = data,
//                let responseData = String(data: data, encoding: .utf8) else {
//                    print("Error: did not receive data")
//                    return
//            }
//
//            // parse the result as JSON
//            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any], let eventArray = jsonDictionary["events"] as? [[String:Any]] else {
//
//                NSLog("Unable to serialize JSON.  Response: \(responseData)")
//                completion([])
//                return
//            }
//
//            var concertArray: [enterLocationForConcerts] = []
//
//            for dict in eventArray {
//                guard let concert =  enterLocationForConcerts(jsonDict: dict) else { return }
//                concertArray.append(concert)
//            }
//
//            completion(concertArray)
//        }
//    }

