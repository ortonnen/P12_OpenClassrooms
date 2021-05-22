//
//  AnnotationCustom.swift
//  MapTest
//
//  Created by Nathalie Simonnet on 16/04/2021.
//

import MapKit
import UIKit

//MARK: - Custom Annitation for Map
final class AnnotationCustom: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    init(title: String, subtitle: String ,coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}
