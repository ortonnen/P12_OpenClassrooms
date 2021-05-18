//
//  MapViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 29/04/2021.
//

import UIKit
import MapKit
import CoreLocation


//MARK: - Map View Controller
class MapViewController: UIViewController {
    //MARK: Properties
    let latitudeInit: Double = 48.90638
    let longitudeInit: Double = 2.03782
    var coordinateInit :  CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)
    }
    let locationManager = CLLocationManager()
    let regionInMeter: Double = 500
    let searchRequest = MKLocalSearch.Request()
    //MARK: Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        mapView.delegate = self
        
        defineInitialLocation()
        searchLocation(for: "food market")
        searchLocation(for: "organic market")
        checkLocationServices()
    }
    
    //MARK: File Private Methods
    ///method to define default location
    fileprivate func defineInitialLocation(){
        
        let region = MKCoordinateRegion.init(center: coordinateInit, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
    }
    ///method to search a place
    fileprivate func searchLocation(for place: String) {
        searchRequest.naturalLanguageQuery = place
        searchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: {(response, error) in
            guard let responsesItem = response?.mapItems else { return }
            for item in responsesItem {
                
                guard let name = item.name else { return }
                guard let info = item.placemark.title else { return }
                let pinAnnotation = MKPointAnnotation()
                pinAnnotation.coordinate = item.placemark.coordinate
                pinAnnotation.title = name
                pinAnnotation.subtitle = info
                
                self.mapView.addAnnotation(pinAnnotation)
            }
        })
    }
    ///method to center map on user
    fileprivate func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
            searchLocation(for: "organic market")
            searchLocation(for: "Food market")
        } else {
            alerte("Erreur", "Une erreur inconnue est survenue, /n merci de rééssayer plus tard", "Ok")
        }
    }
    ///method to check if user location have authorization
    fileprivate func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            searchLocation(for: "organic market")
            searchLocation(for: "market")
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    ///method to check if location service is enabled
    fileprivate func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            let region = MKCoordinateRegion.init(center: coordinateInit, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
        }
    }
    fileprivate func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}
//MARK: - Alerte
extension MapViewController{
    /// user Alerte
    private func alerte(_ title: String, _ message: String, _ buttonTitle: String) {
        let alerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerteAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        alerte.addAction(alerteAction)
        self.present(alerte, animated: true, completion: nil)
    }
}
//MARK: - MapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let title = annotation.title else { return annotation as? MKAnnotationView }
        guard let subtitle = annotation.subtitle else { return annotation as? MKAnnotationView}
        let customAnnotation = AnnotationCustom(title: title ?? "", subtitle: subtitle ?? "", coordinate: annotation.coordinate)
        let identifier = "Annotation"
        var dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if  dequeuedView == nil {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.pinTintColor = #colorLiteral(red: 0.95542413, green: 0.6744924188, blue: 0.4416911602, alpha: 1)
            dequeuedView = annotationView
            dequeuedView?.annotation = customAnnotation
            dequeuedView?.canShowCallout = true
            
        } else {
            dequeuedView?.annotation = annotation
        }
        return dequeuedView
    }
}
//MARK: - Location
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

