//
//  StatesController.swift
//  Capstone
//
//  Created by Martin Kirke on 1/18/17.
//  Copyright © 2017 Ghost. All rights reserved.
//

import Foundation

class StatesController {
    
    static var shared = StatesController()
    
    var dict: [[String:Any]] = [] {
        didSet { print(dict)
        }
    }
    
    func parse() {
        
        if let filePath = Bundle.main.path(forResource: "States", ofType: "json"), let data = NSData(contentsOfFile: filePath) {
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary else { return }
                dict.append(jsonResult as! [String : Any])
                //print(dict.description)
            }
            catch {
                print("Error Getting Data")
            }
        }
    }}
