//
//  CitySelectorViewController.swift
//  CityRundown
//
//  Created by William Moody on 8/19/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit
import MapKit

class CitySelectorViewController: UIViewController {

    //Outlets
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var SearchResultTableView: UITableView!
    
    //search variables
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var cityName: String? = ""
    var cityAdmin: String? = ""
    var cityNameAndAdmin: String = ""
    
    //mapKit variables
    
    let regionRadius: CLLocationDistance = 50000
    var cityArraySet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self
        MapView.delegate = self
        SearchResultTableView.isHidden = true
        self.hideKeyboardWhenTappedOutside()
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        MapView.addGestureRecognizer(longTapGesture)
        if cityNameAndAdmin == "" {
            cityArraySet = true
        }
    }
    
    //MARK: - Mapkit Funtions
    
    func queryForStringArray(cityArray: [String]){
        for city in cityArray {
            searchCompleter.queryFragment = city
        }
        cityArraySet = true
    }
    
    func addAnnotation(location: CLLocationCoordinate2D, name: String, subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = name
        annotation.subtitle = subtitle
        
        self.MapView.addAnnotation(annotation)
        self.MapView.selectAnnotation(annotation, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: MapView)
            let locationOnMap = MapView.convert(locationInView, toCoordinateFrom: MapView)
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: locationOnMap.latitude, longitude: locationOnMap.longitude)
            geoCoder.reverseGeocodeLocation(location) { (placeMark, error) in
                
                guard let placeMark = placeMark?.first else {return}
                var cityOnPin = ""
                var stateOfCity = ""
                if let city = placeMark.locality {
                    cityOnPin = city
                }
                
                if let state = placeMark.administrativeArea {
                    stateOfCity = state
                }
                self.addAnnotation(location: locationOnMap, name: cityOnPin, subtitle: stateOfCity)
                self.centerMapOnLocation(location: location)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CitySelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return
        }
        searchCompleter.queryFragment = searchText
        SearchResultTableView.isHidden = false
    }
}

extension CitySelectorViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
        SearchResultTableView.reloadData()
        if !cityArraySet {
            let test = CGPoint(x: 0, y: 0)
            let indexPath = SearchResultTableView.indexPathForRow(at: test)!
            tableView(SearchResultTableView, didSelectRowAt: indexPath)
            cityArraySet = true
        }
    }
    // Present Alert Controller with an error if not able to return results
}

extension CitySelectorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    fileprivate func populateMapView(int: Int) {
        let mkCompletionForIndexPath = searchResults[int]
        
        let searchRequest = MKLocalSearch.Request(completion: mkCompletionForIndexPath)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            if let cityNameForSelectedRow = response?.mapItems[0].placemark.locality {
                self.cityName = cityNameForSelectedRow
            }
            
            if let stateNameForSelectedRow = response?.mapItems[0].placemark.administrativeArea {
                self.cityAdmin = stateNameForSelectedRow
                guard self.cityAdmin != nil else { return }
            }
            
            if let coordinate = response?.mapItems[0].placemark.coordinate {
                let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                print(String(describing: coordinate))
                print("location for selected cell changed to: \(coordinate.latitude), \(coordinate.longitude)")
                
                print(response!.mapItems[0].placemark)
                
                self.addAnnotation(location: location, name: self.cityName ?? "No city found", subtitle: "\(self.cityAdmin ?? "State not found")")
                self.SearchBar.text = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        populateMapView(int: indexPath.row)
        tableView.isHidden = true
    }
}

extension CitySelectorViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {print("no mkpoint anotations"); return nil}
        
        let reuseID = "locationPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.black
            pinView?.animatesDrop = true
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailVC") as? LocationDetailViewController else {return}
            self.addChild(detailVC)
            detailVC.view.frame = self.view.frame
            self.view.addSubview(detailVC.view)
            detailVC.didMove(toParent: self)
            
            
            guard let annotation = view.annotation else {return}
            guard let title = annotation.title,
                let state = annotation.subtitle else {return}
            detailVC.cityName = title!
            detailVC.cityAdmin = state!
            detailVC.cityCoords = view.annotation?.coordinate
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.resignFirstResponder()
        
    }
}
