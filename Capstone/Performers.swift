//
//  Performers.swift
//  Capstone
//
//  Created by Martin Kirke on 1/18/17.
//  Copyright © 2017 Ghost. All rights reserved.
//

import Foundation

class Performers {
    
    private let kImage = "image"
    //    private let kGenres = ""
    private let kType = "type"
    private let kName = "name"
    private let kUrl = "url"
    
    
    //    var genres: String
    var nameArray: [String] = []
    var artistURL: String
    var imageURL: String
    
    init(name: [String], url: String, imageURL: String) {
        //        self.genres = genres
        self.nameArray = name
        self.artistURL = url
        self.imageURL = imageURL
    }
    
    
    init?(JsonDict: [String : Any]) {
        guard let imageDict = JsonDict["image"] as? [[String:String]] else { return nil }
        
        for image in imageDict {
            if image["size"] == "extralarge" {
                guard let imageURL = image["#text"] else { break }
                self.imageURL = imageURL
            }
        }
        
        guard let name = JsonDict[kName] as? String,
            let artistURL = JsonDict[kUrl] as? String else
        { return nil }
        
        
        self.artistURL = artistURL
        
        if name.contains("+") || name.contains("%") || name.contains("[") || name.contains("]") || name.contains("_") || name.contains("?") || name.contains("~") || name.contains("/") || name.contains("perform") || name.contains(" ft ") || name.contains("feat") || name.contains("(") || name.contains(")") || name.contains("&") || name.contains(",") || name.contains("vs") || name.contains(" x ") || name.contains(" X ") || name.contains(" Feat ") || name.contains(" Ft ") || name.contains(" Ft. ") || name.contains(" Feat. ") || name.contains("@") || name.contains(" ft. ") || name.contains(".com") || name.contains(";") || name.contains(" + ") || name.contains(" f ") || name.contains("www") || name.contains("and")  || name.contains("Vs") || name.contains("VS") || name.contains("f.") || name.contains(" - ") || name.contains("1") || name.contains("2") || name.contains("3") || name.contains("4") || name.contains("5") || name.contains("6") || name.contains("7") || name.contains("8") || name.contains("9") || name.contains("0") {
            print("no")
        } else {
            nameArray.append(name)
        }
    }
}
