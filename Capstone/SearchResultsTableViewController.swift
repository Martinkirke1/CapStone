//
//  SearchResultsTableViewController.swift
//  Capstone
//
//  Created by Martin Kirke on 12/8/16.
//  Copyright © 2016 Ghost. All rights reserved.
//

import UIKit
import CoreLocation

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate  {
    
    
    //Property
    
    var nameVenue = ""
    
    var cityArray = [String]()
    var venueArray = [String]()
    var urlArray = [String]()
    var imageArray = [String]()
    //CityState Properties
    
    var cityStateNameArray = [String]()
    
    //Venue Properties
    
    var venueSearchName = [String]()
    
    //Artist Properties
    
    var artistSearchName = [String]()
    
    //==================================================
    // MARK: -ViewDidLoad
    //==================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search by Venue"
        searchBar.delegate = self
        
        let white = UIColor.gray
        
        SearchSegment.layer.cornerRadius = -1.0
        SearchSegment.layer.borderColor = white.cgColor
        SearchSegment.layer.borderWidth = 1
        SearchSegment.layer.masksToBounds = true
        
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        ConcertController.shared.fetchTopVenues(completion: { (topVenues) in
            
            for venue in topVenues {
                let score = venue.score
                let venueInfo = venue.name
                //                    let score = venue.url
                
                self.cityArray.append("\(score)")
                self.venueArray.append(venueInfo)
                //                    self.urlArray.append(url)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var SearchSegment: UISegmentedControl!
    
    var searchValue = 0
    @IBAction func SearchSegmentTapped(_ sender: Any) {
        switch SearchSegment.selectedSegmentIndex {
        case 0:
            searchValue = 0
            searchBar.placeholder = "Search by Venue"
            self.venueArray = []
            self.cityArray = []
            ConcertController.shared.fetchTopVenues(completion: { (topVenues) in
                
                for venue in topVenues {
                    let score = venue.score
                    let venueInfo = venue.name
                    
                    self.cityArray.append("\(score)")
                    self.venueArray.append(venueInfo)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            
            
            
            
        case 1:
            searchValue = 1
            searchBar.placeholder = "Search by Artist"
            
            self.venueArray = []
            self.cityArray = []
            
            ConcertController.shared.topArtistbyCountry(Country: "spain", completion: { (topArtist) in
                guard let artist = topArtist else { return }
                self.venueArray = artist.nameArray
                self.cityArray = artist.urlArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            
        case 2:
            searchValue = 2
            searchBar.placeholder = "Search by City, State"
            self.venueArray = []
            self.cityArray = []
            guard let location = locationManager.location else { return }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            ConcertController.shared.fetchVenueLocation(lat: latitude, lon: longitude) { (ConcertLocation) in
                
                for venue in ConcertLocation {
                    let city = venue.city
                    let venueInfo = venue.name
                    let url = venue.url
                    
                    self.cityArray.append(city)
                    self.venueArray.append(venueInfo)
                    self.urlArray.append(url)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        default:
            break
        }
    }
    
    
    
    var locationManager = LocationController.sharedController.locationManager
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text else { return }
        
        switch searchValue {
        case 0:
            print(searchValue)
            DispatchQueue.main.async {
                ConcertController.shared.fetchVenueNameBySearchTerm(searchTerm: searchTerm, completion: { (VenueInfo) in
                    
                    self.venueArray = []
                    self.cityArray = []
                    for venue in VenueInfo {
                        let name = venue.name
                        let city = venue.city
                        self.venueArray.append(name)
                        self.cityArray.append(city)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                    // reload tv
                })
            }
        case 1:
            self.venueArray = []
            self.cityArray = []
            ConcertController.shared.artistBySearchTermAPI(searchTerm: searchTerm, completion: { (artistInfo) in
                guard let artist = artistInfo else { return }
                self.venueArray = artist.nameArray
                self.cityArray = artist.urlArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        case 2:
            print(searchValue)
            self.venueArray = []
            self.cityArray = []
            ConcertController.shared.fetchVenueBySearch(searchTerm: searchTerm, completion: { (ConcertInfo) in
                for info in ConcertInfo {
                    let name = info.name
                    let city = info.city
                    self.venueArray.append(name)
                    self.cityArray.append(city)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            })
        default:
            break
        }
        searchBar.resignFirstResponder()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // Handle if the user has granted authorization for location services before requesting location
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return venueArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        
        
        cell.textLabel?.text = venueArray[indexPath.row]
        cell.detailTextLabel?.text = cityArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if searchValue == 0 {
            performSegue(withIdentifier: "venueSegue", sender: self)
        } else if searchValue == 1 {
            performSegue(withIdentifier: "artistSegue", sender: self)
        } else if searchValue == 2 {
            performSegue(withIdentifier: "venueSegue", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "venueSegue" {
            if let DVC = segue.destination as? VenueInfoViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                
            }
            
        } else if segue.identifier == "artistSegue" {
            if let DVC = segue.destination as? ArtistInfoViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                DVC.artistURL = venueArray[selectedRow]
                DVC.passedArtistName = cityArray[selectedRow]
            }
        }
        
    }
    
    //        let urlAlert = UIAlertController(title: "Tickets", message: "Would you like to open a webpage to see tickets?", preferredStyle: .alert)
    //        let urlAction = UIAlertAction(title: "OK", style: .default) { (_) in
    //            ""
    //        }
    //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    //        urlAlert.addAction(urlAction)
    //        urlAlert.addAction(cancelAction)
    //
    //        present(urlAlert, animated: true, completion: nil)
    //
    //        //        urlArray[indexPath.row]


func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    
}

func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Errors" + error.localizedDescription)
}




/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */


 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 
}
