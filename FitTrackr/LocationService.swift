//
//  RunDataManager.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/21/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import Foundation
import MapKit


protocol LocationServiceDelegate {
    func getLocationData(locations: [CLLocation])
    
    func getSpeedData(speed: CLLocationSpeed?)
}


class LocationService: NSObject, CLLocationManagerDelegate {
    
    var delegate: LocationServiceDelegate?

    
    
    var runLocations: [CLLocation] = []
    var runDistance: [CLLocationDistance] = []
    var pausedDistance: [CLLocationDistance] = [] // Stores distance added to runLocations if workout is paused
    var speed: CLLocationSpeed?
    var pace: Double?
    
    
    let locationManager: CLLocationManager?
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            print("location enabled")
        } else {
            print("location not enabled")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.delegate?.getLocationData(locations: locations)
        
        let currentSpeed = self.locationManager?.location?.speed
        self.delegate?.getSpeedData(speed: currentSpeed)

        
        
        /*
        runLocations.append(locations[0] as CLLocation)
        if (runLocations.count > 1){
            let sourceIndex = runLocations.count - 1
            let destinationIndex = runLocations.count - 2
            
            let coordinate1 = runLocations[sourceIndex].coordinate
            let coordinate2 = runLocations[destinationIndex].coordinate
            
            var distanceArray = [coordinate1, coordinate2]
            
            // var aPaused = [locationManager!.location!.coordinate, c1]
            let distInMiles = (myLocations[destinationIndex].distance(from: runLocations[sourceIndex])) / 1609
            runDistance.append(distInMiles)
            
            
            
            
            let miles = distance.reduce(0, +) - pausedDistance.reduce(0,+)
            // let milesString = String(format: "%.02f", miles)
            
            
            speed = locationManager?.location?.speed
            if let speedInMetersPerSecond = speed {
                let speedInMilesPerHour = max(2.23694 * speedInMetersPerSecond, 0)
                //let speedString = String(format: "%.02f", speedInMilesPerHour)
                
                pace =  1 / (miles / (Double(elapsedTime)))
                
                
                //let minutes = (Double(pace!) / 60).truncatingRemainder(dividingBy: 60)
               // let seconds = Double(pace!).truncatingRemainder(dividingBy: 60)
               // let paceStr = String(format:"%.0f:%.0f", minutes, seconds)
                
                
            }
            
        }
 */
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    } 
    

    
    
    
}
