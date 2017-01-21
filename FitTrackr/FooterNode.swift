//
//  FooterNode.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/20/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import ChameleonFramework

class FooterNode: ASDisplayNode {
    
    
    var timer: Timer?
    
    enum WorkoutState {
        case running, stopped, pending
    }
    
    
    let startWorkoutButton = ASButtonNode()
    
    let buttonFont = UIFont.systemFont(ofSize: 18)
    let initialButtonBgColor = UIColor.black
    let buttonTextColor = UIColor.white
    let selectedButtonBgColor = UIColor.red
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        startWorkoutButton.setTitle("Begin Workout", with: buttonFont, with: buttonTextColor, for: [ ])
        startWorkoutButton.backgroundColor = initialButtonBgColor
        startWorkoutButton.borderColor = UIColor.black.cgColor
        startWorkoutButton.borderWidth = 3
        startWorkoutButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        
                
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        startWorkoutButton.style.preferredSize = CGSize(width: 150, height: 30)
        let insets = UIEdgeInsets(top: CGFloat.infinity, left: 30, bottom: 10, right: 30)
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: startWorkoutButton)
        
    }
    
    override func didLoad() {
        self.backgroundColor = UIColor.red
    }
    

}
