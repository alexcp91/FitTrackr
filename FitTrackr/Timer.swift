//
//  Timer.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/21/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import Foundation
import UIKit
import MapKit


protocol TimerDelegate: class {
    func getTime(time: TimeInterval?)
}


class Timer {
    
    // Constants
    
    var appDelegate: AppDelegate?
    var locationManager: CLLocationManager?
   
    
    
    var delegate: TimerDelegate?
    
    private var displayLink: CADisplayLink?
    
    var timeString: String?
    
    var elapsedTime: TimeInterval {
        switch state {
        case .Stopped: return endTime - startTime
        case .Running: return CFAbsoluteTimeGetCurrent() - startTime
        case .Pending: return 0
            
        }
    }
    
    private var state = State.Stopped {
        didSet {
            
            updateLabel()
        }
    }
    
    private enum State {
        case Stopped
        case Pending
        case Running
    }
    
    private var startTime: CFAbsoluteTime = 0
    private var pauseTime: CFAbsoluteTime = 0
    
    private var endTime: CFAbsoluteTime = 0 {
        didSet {
            updateLabel()
        }
    }
    
    // Init
    
    // Functions
    
    
    func startTimer() {
        createDisplayLinkIfNeeded()
        print("timer fired!")
        
        switch state {
        case .Stopped:
            if startTime == 0 {
                startTime = CFAbsoluteTimeGetCurrent() }
            else {
                startTime += CFAbsoluteTimeGetCurrent() - pauseTime
                /*
                 let currentLocation = locationManager?.location
                 let lastLocationIndex = myLocations.count - 1
                 let lastLocation = myLocations[lastLocationIndex]
                 let pausedDist = currentLocation!.distance(from: lastLocation) / 1609
                 pausedDistance.append(pausedDist)
                 */
                
            }
            displayLink?.isPaused = false
            state = .Running
            // startTimerButton.setTitle("Pause", with: UIFont.systemFont(ofSize:18), with: UIColor.black, for: [ ])
            // !.startUpdatingLocation()
            
        case .Pending:
            startTime = CFAbsoluteTimeGetCurrent()
            displayLink?.isPaused = false
            state = .Running
            // startTimerButton.setTitle("Pause", with: UIFont.systemFont(ofSize:18), with: UIColor.black, for: [ ])
            // locationManager!.startUpdatingLocation()
            
            
        case .Running:
            state = .Stopped
            pauseTime = CFAbsoluteTimeGetCurrent()
            
            endTime = CFAbsoluteTimeGetCurrent()
            // locationManager!.stopUpdatingLocation()
            
            displayLink?.isPaused = true
            // startTimerButton.setTitle("Start", with: UIFont.systemFont(ofSize:18), with: UIColor.black, for: [ ])
        }
        
    }
    
    
    
    private func createDisplayLinkIfNeeded() {
        guard self.displayLink == nil else { return }
        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidFire(_:)))
        displayLink.isPaused = true
        displayLink.add(to: RunLoop.main, forMode: .commonModes)
        self.displayLink = displayLink
        
        
    }
    
    @objc func displayLinkDidFire(_: CADisplayLink) {
        updateLabel()
    }
    
    
    
    
    
    /*
     @objc private func resetButtonTapped(_: Any) {
     state = .Pending
     // startTimerButton.setTitle("Start", with: UIFont.systemFont(ofSize:18), with: UIColor.black, for: [ ])
     startTime = 0
     pauseTime = 0
     endTime = 0
     
     
     }
     */
    
    
    private func updateLabel() {
        self.delegate?.getTime(time: elapsedTime)
        
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        timeString = String(format:"%02i:%02i:%02i", hours, minutes, seconds)

    
    }
    
}



