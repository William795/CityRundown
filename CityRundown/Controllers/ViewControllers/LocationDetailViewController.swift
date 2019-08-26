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
            callAPIs()
        }
    }
    
    var businesses: [Business] = []
    var weatherForecast: Forecast?
    
    var regionRadius:CLLocationDistance = 30000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yelpMapview.delegate = self
        yelpTableview.delegate = self
        yelpTableview.dataSource = self
    }
    
    //call APIs
    
    func callAPIs() {
        
        yelpAPICall(location: cityName + cityAdmin)
        weatherAPICall()
    }
    
    func yelpAPICall(location: String) {
        
        YelpController.shared.fetchPlaceYelp(WithLocation: location) { (business) in
            self.businesses = business ?? []
            self.setBusinesses(business: self.businesses)
            DispatchQueue.main.async {
                self.yelpTableview.reloadData()
            }
        }
    }
    
    func weatherAPICall() {
        
        guard let coords = cityCoords else {return}
        ForecastController.shared.getForecastFor(cityName: cityName, location: coords) { (forecast) in
            self.weatherForecast = forecast
            self.updateWeatherLabels()
        }
    }
    
    //update weather labels and images
    func updateWeatherLabels() {
        
        guard let forecast = weatherForecast else {return}
        DispatchQueue.main.async {
            self.dayOneLow.text = "\(forecast.daily.data[0].temperatureLow)ºF"
            self.dayOneHigh.text = "\(forecast.daily.data[0].temperatureHigh)ºF"
            self.dayOnePrecipitation.text = "\(forecast.daily.data[0].precipProbability)%"
            self.dayTwoLow.text = "\(forecast.daily.data[0].temperatureLow)ºF"
            self.dayTwoHigh.text = "\(forecast.daily.data[0].temperatureHigh)ºF"
            self.dayTwoPrecipitation.text = "\(forecast.daily.data[0].precipProbability)%"
            self.dayThreeLow.text = "\(forecast.daily.data[0].temperatureLow)ºF"
            self.dayThreeHigh.text = "\(forecast.daily.data[0].temperatureHigh)ºF"
            self.dayThreePrecipitation.text = "\(forecast.daily.data[0].precipProbability)%"
        }
    }
    
    //MARK: - yelp annotations and table view
    
    func setBusinesses(business: [Business]) {
        if business.isEmpty {
            return
        }
        addAnnotationsOfYelpData(businesses: business)
    }
    
    func addAnnotation(location: CLLocationCoordinate2D, name: String, subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = name
        annotation.subtitle = subtitle
        
        self.yelpMapview.addAnnotation(annotation)
    }
    
    func addAnnotationsOfYelpData(businesses: [Business]) {
        
        for business in businesses {
            let coordinates = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
            self.addAnnotation(location: coordinates, name: business.name, subtitle: business.categories[0].title ?? "")
        }
        let location = CLLocation(latitude: businesses[0].coordinates.latitude, longitude: businesses[0].coordinates.longitude)
        self.centerMapOnLocation(location: location)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        yelpMapview.setRegion(coordinateRegion, animated: true)
    }
    
    func showChildViewOf(business: Business) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "yelpDetail") as? YelpLocationInfoVC else {return}
        self.addChild(detailVC)
        detailVC.view.frame = self.view.frame
        self.view.addSubview(detailVC.view)
        detailVC.didMove(toParent: self)
        
        detailVC.placeNameLabel.text = business.name
        detailVC.placePriceLabel.text = business.price
        detailVC.placeRatingLabel.text = "\(business.rating)"
        detailVC.placeReviewCountLabel.text = "\(business.review_count)"
        detailVC.placeAddressLabel.text = business.location.address1
        detailVC.placeCategoryLabel.text = business.categories[0].title
        
        if business.price?.isEmpty ?? true {
            detailVC.placePriceLabel.text = "N/A"
        }
        YelpController.shared.fetchYelpBusinessImage(business: business) { (image) in
            DispatchQueue.main.async {
                detailVC.placeImageView.image = image
            }
        }
    }
}

extension LocationDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            for business in businesses {
                if business.name == view.annotation?.title {
                    showChildViewOf(business: business)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {print("no mkpoint anotations"); return nil}
        
        let reuseID = "locationPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.red
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
}

extension LocationDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        
        let business = businesses[indexPath.row]
        
        cell.textLabel?.text = business.name
        cell.detailTextLabel?.text = business.categories[0].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let business = businesses[indexPath.row]
        for annotation in yelpMapview.annotations {
            if business.name == annotation.title {
                let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                self.regionRadius = 500
                centerMapOnLocation(location: location)
                yelpMapview.selectAnnotation(annotation, animated: true)
            }
        }
    }
}
