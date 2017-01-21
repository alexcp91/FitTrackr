//
//  RunDataManager.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/21/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import Foundation
import MapKit

protocol RunDataManagerDelegate {
    func getRunDistanceData(runLocations: [CLLocation], runDistance: [CLLocationDistance])
    
    func getSpeedInMPH(speed: CLLocationSpeed?)
    
    //func getElapsedTime(time: TimeInterval?)
    
    
}

class RunDataManager: LocationServiceDelegate {
        
    var delegate: RunDataManagerDelegate?
    
    var runLocations: [CLLocation] = []
    var runDistance: [CLLocationDistance] = []
    var pausedDistance: [CLLocationDistance] = [] // Stores distance added to runLocations if workout is paused
    
    var speed: CLLocationSpeed = 0
    var pace: Double = 0
    
    var elapsedTime: TimeInterval?
    
    func getLocationData(locations: [CLLocation]) {
        NotificationCenter.default.post(name: Notification.Name("LocationDataNotification"), object: nil)
        runLocations.append(locations[0] as CLLocation)
        
        
        if runLocations.count > 1 {
            let sourceIndex = runLocations.count - 1
            let destinationIndex = runLocations.count - 2
            
            let coordinate1 = runLocations[sourceIndex].coordinate
            let coordinate2 = runLocations[destinationIndex].coordinate
            
            var distanceArray = [coordinate1, coordinate2]
            
            
            let distInMiles = (runLocations[destinationIndex].distance(from: runLocations[sourceIndex])) / 1609
            runDistance.append(distInMiles)
        }
        self.delegate?.getRunDistanceData(runLocations: runLocations, runDistance: runDistance)
        
    }
    
    func getSpeedData(speed: CLLocationSpeed?) {
        if let speedInMetersPerSecond = speed {
            let speedInMilesPerHour = max(2.23694 * speedInMetersPerSecond, 0)
            self.speed = speedInMilesPerHour
        }
        self.delegate?.getSpeedInMPH(speed: speed)
    }
    
}

  
