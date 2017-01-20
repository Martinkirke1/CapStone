//
//  TopArtistByCountry.swift
//  Capstone
//
//  Created by Martin Kirke on 1/19/17.
//  Copyright © 2017 Ghost. All rights reserved.
//

import Foundation


class topArtistByCountry {
    
    private let kImage = "image"
    private let kName = "name"
    private let kUrl = "url"
    
    
    var nameArray: [String] = []
    var urlArray: [String] = []
    
    init(name: [String], url: [String]) {
        self.nameArray = name
        self.urlArray = url
    }
    
    init?(JsonDict: [String : Any]) {
        guard let nameDict = JsonDict["topartists"] as? [String:Any],
            let artist = nameDict["artist"] as? [[String:Any]]
            else {
                return nil }
        for dict in artist {
            guard let name = dict[kName] as? String,
                let url = dict[kUrl] as? String else {
                    return nil }
            nameArray.append(name)
            urlArray.append(url)
        }
        
    }
    
}
