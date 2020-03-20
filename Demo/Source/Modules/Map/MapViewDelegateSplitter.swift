//
//  MapViewDelegate.swift
//  Demo
//
//  Created by Scott Levie on 9/15/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import MapKit

/*
protocol MKMapViewAnnotationDelegate: class {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView])
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
}

class MapViewDelegateSplitter: NSObject, MKMapViewDelegate {

    init(_ mapView: MKMapView) {
        super.init()
        mapView.delegate = self
    }

    weak var annotationDelegate: MKMapViewAnnotationDelegate?


    // MARK: - MKMapViewDelegate


    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {}

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {}

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {}

    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {}

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {}

    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {}

    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {}

    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {}

    // MARK: Annotation View

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        self.annotationDelegate?.mapView(mapView, viewFor: annotation)
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        self.annotationDelegate?.mapView(mapView, didAdd: views)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.annotationDelegate?.mapView(mapView, annotationView: view, calloutAccessoryControlTapped: control)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.annotationDelegate?.mapView(mapView, didSelect: view)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.annotationDelegate?.mapView(mapView, didDeselect: view)
    }

    // MARK: User Location

    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {}

    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {}

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {}

    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {}

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {}

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {}

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {}

    func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {}

    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {}
}
*/
