//
//  HeaderDataNode.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/20/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HeaderDataNode: ASDisplayNode, RunDataManagerDelegate {
    
    
    let backgroundContainer = ASDisplayNode()
    let speedLabel = ASTextNode()
    let speedData = ASTextNode()
    let timeLabel = ASTextNode()
    let timeData = ASTextNode()
    let distanceLabel = ASTextNode()
    let distanceData = ASTextNode()
    let paceLabel = ASTextNode()
    let paceData = ASTextNode()
    let caloriesLabel = ASTextNode()
    let caloriesData = ASTextNode()
    
    let textDataAttrs = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 24),
        NSForegroundColorAttributeName: UIColor.darkGray
        
        ]
    
    let distanceDataAttrs = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 48),
        NSForegroundColorAttributeName: UIColor.darkGray
        
    ]
    
    let textLabelAttrs = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: UIColor.darkGray
        
    ]
    
    
   override init() {
    
        super.init()
    
        automaticallyManagesSubnodes = true
    
        speedLabel.attributedText = NSAttributedString(string: "Speed (MPH)", attributes: textLabelAttrs)
        timeLabel.attributedText = NSAttributedString(string: "Time", attributes: textLabelAttrs)
        distanceLabel.attributedText = NSAttributedString(string: "Distance (miles)", attributes: textLabelAttrs)
        paceLabel.attributedText = NSAttributedString(string: "Pace (Min/Mi)", attributes: textLabelAttrs)
        caloriesLabel.attributedText = NSAttributedString(string: "Calories", attributes: textLabelAttrs)
    
        speedData.attributedText = NSAttributedString(string: "0.00", attributes: textDataAttrs)
    
        timeData.attributedText = NSAttributedString(string: "00:00", attributes: textDataAttrs)
        distanceData.attributedText = NSAttributedString(string: "0.00", attributes: distanceDataAttrs)
        paceData.attributedText = NSAttributedString(string: "0:00", attributes: textDataAttrs )
        caloriesData.attributedText = NSAttributedString(string: "0", attributes: textDataAttrs )

    
    }
    
    override func didLoad() {
      self.backgroundColor = UIColor.white
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        
        
        let speedLabelSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .center, children: [speedLabel, speedData])
        
        let timeLabelSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .center, children: [timeLabel, timeData])
       
        
        let paceLabelSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .center, children: [paceLabel, paceData])

        let caloriesLabelSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .center, children: [caloriesLabel, caloriesData])
        
        let distanceLabelSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .center, children: [distanceData, distanceLabel])
        
        
        let topStack = ASStackLayoutSpec(direction: .horizontal, spacing: 30, justifyContent: .spaceAround, alignItems: .center, children: [speedLabelSpec, timeLabelSpec])
        
        let middleStack = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: distanceLabelSpec)
        
        let bottomStack = ASStackLayoutSpec(direction: .horizontal, spacing: 30, justifyContent: .spaceAround, alignItems: .center, children: [paceLabelSpec, caloriesLabelSpec])
        
        let totalStack = ASStackLayoutSpec(direction: .vertical, spacing: 80, justifyContent: .center, alignItems: .center, children: [topStack, middleStack, bottomStack])
        
        let insets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return ASInsetLayoutSpec(insets: insets, child: totalStack)
     }
    
    
    func getRunDistanceData(runLocations: [CLLocation], runDistance: [CLLocationDistance]) {
        
        let miles =  runDistance.reduce(0, +) //- pausedDistance.reduce(0,+)
        let milesString = String(format: "%.02f", miles)
        distanceData.attributedText = NSAttributedString(string: milesString, attributes: distanceDataAttrs)
        
        
    }
    
    func getSpeedInMPH(speed: CLLocationSpeed?) {
        if let speedStr = speed {
            let speedString = String(format: "%.02f", speedStr)
            speedData.attributedText = NSAttributedString(string: speedString, attributes: textDataAttrs)
        }
    }
    
    
    
}
