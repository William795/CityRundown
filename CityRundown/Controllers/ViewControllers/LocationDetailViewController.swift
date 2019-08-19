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
