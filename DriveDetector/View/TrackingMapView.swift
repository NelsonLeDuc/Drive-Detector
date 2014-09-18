//
//  TrackingMapView.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit
import MapKit

public class TrackingMapView: UIView, MKMapViewDelegate
{
    public var trackUser: Bool
    {
        didSet
        {
            self.updateMapViewWithTracking(trackUser)
        }
    }
    public var manualLocationTracking: Bool
    
    private var trackingUser: Bool
    
    private var mapView: MKMapView
    private var linePositions: [CLLocation]
    private var polyline: MKPolyline?
    private var lineColor: UIColor?
    
    //MARK: - Init
    required public init(coder aDecoder: NSCoder)
    {
        self.trackUser = true
        self.manualLocationTracking = false
        self.trackingUser = false
        
        self.mapView = MKMapView(frame: CGRectZero)
        self.linePositions = [CLLocation]()
        
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    //MARK: - Public Methods
    func updateLineLocation(location: CLLocation)
    {
        if self.manualLocationTracking
        {
            self.addLocationToArray(location)
        }
    }
    
    func endCurrentLine()
    {
        if self.polyline?.pointCount < 10
        {
            self.mapView.removeOverlay(self.polyline)
        }
        
        self.polyline = nil
        self.linePositions = [CLLocation]()
        self.lineColor = nil
    }
    
    //MARK: Private Methods
    func setupView()
    {
        self.mapView.delegate = self
        self.mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(self.mapView)
        
        let bindings: [NSObject:AnyObject] = [ "mapView" : self.mapView ]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: bindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: bindings))
        
        self.layoutIfNeeded()
        
        self.updateMapViewWithTracking(true)
    }
    
    func updateMapViewWithTracking(tracking: Bool)
    {
        self.mapView.userTrackingMode = tracking ? .FollowWithHeading : .None
        self.mapView.scrollEnabled = !tracking
    }
    
    //MARK: - MKMapViewDelegate
    public func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!)
    {
        if !self.trackingUser
        {
            self.trackingUser = true
            self.updateMapViewWithTracking(true)
        }
        
        if !self.manualLocationTracking
        {
            self.addLocationToArray(userLocation.location)
        }
    }
    
    public func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!
    {
        if self.lineColor == nil
        {
            self.lineColor = UIColor.randomColor()
        }
        
        var renderer = MKPolylineRenderer(polyline: overlay as MKPolyline)
        renderer.strokeColor = self.lineColor
        renderer.lineWidth = 5
        
        return renderer
    }
    
    func addLocationToArray(location: CLLocation)
    {
        if let lastPos = self.linePositions.last
        {
            if location.distanceFromLocation(lastPos) > 100
            {
                self.endCurrentLine()
            }
        }
        
        self.linePositions.append(location)
        var coordinates = [CLLocationCoordinate2D]()
        for linePosition in self.linePositions
        {
            coordinates.append(linePosition.coordinate)
        }
        
        self.mapView.removeOverlay(self.polyline)
        self.polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        self.mapView.addOverlay(self.polyline)
    }
}