//
//  ArtistInfoViewController.swift
//  Capstone
//
//  Created by Martin Kirke on 1/20/17.
//  Copyright © 2017 Ghost. All rights reserved.
//

import UIKit

class ArtistInfoViewController: UIViewController {

    @IBOutlet weak var ticketURL: UILabel!
    
    @IBOutlet weak var artistName: UILabel!
    
    var artistURL = ""
    var passedArtistName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ticketURL.text = artistURL
        artistName.text = passedArtistName
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
