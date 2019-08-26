//
//  YelpLocationInfoVC.swift
//  CityRundown
//
//  Created by William Moody on 8/26/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class YelpLocationInfoVC: UIViewController {

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeCategoryLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeReviewCountLabel: UILabel!
    @IBOutlet weak var placeRatingLabel: UILabel!
    @IBOutlet weak var placePriceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
