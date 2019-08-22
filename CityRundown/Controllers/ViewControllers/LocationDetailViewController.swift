//
//  LocationDetailViewController.swift
//  CityRundown
//
//  Created by William Moody on 8/19/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var dayOnePrecipitation: UILabel!
    @IBOutlet weak var dayOneHigh: UILabel!
    @IBOutlet weak var dayOneLow: UILabel!
    
    @IBOutlet weak var dayTwoPrecipitation: UILabel!
    @IBOutlet weak var dayTwoHigh: UILabel!
    @IBOutlet weak var dayTwoLow: UILabel!
    
    @IBOutlet weak var dayThreePrecipitation: UILabel!
    @IBOutlet weak var dayThreeHigh: UILabel!
    @IBOutlet weak var dayThreeLow: UILabel!
    
    @IBOutlet weak var yelpMapview: MKMapView!
    @IBOutlet weak var yelpTableview: UITableView!
    
    var cityName: String = ""
    var cityAdmin: String = ""
    var cityCoords: CLLocationCoordinate2D? {
        didSet {
            //fetch from apis here
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func yelpAPICall(location: String) {
        
    }
    
    func weatherAPICall() {
        
    }
    
    //big fetch
    
    //update weather labels and images

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
