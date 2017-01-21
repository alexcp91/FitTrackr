//
//  RunViewController.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/20/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class RunViewController: ASViewController<ASDisplayNode> {
    
    // Constants
    let initialNode: ASDisplayNode
    let blueRectangle: ASDisplayNode
    let redRectangle: ASDisplayNode
    var rectangleState: rectangleColors = .red
    
    
    enum rectangleColors {
        case blue, red
    }
    
    init() {
        initialNode = ASDisplayNode()
        blueRectangle = ASDisplayNode()
        redRectangle = ASDisplayNode()
        
        

        
        super.init(node: initialNode)
        initialNode.automaticallyManagesSubnodes = true
        
        self.initialNode.layoutSpecBlock = { node in
            
            let activeRectangle: ASDisplayNode
            
            if self.rectangleState == .red {
                activeRectangle = self.redRectangle
            } else {
                activeRectangle = self.blueRectangle
            }
            
            let stack = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: activeRectangle)
            
            let insets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            return ASInsetLayoutSpec(insets: insets, child: stack)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print(initialNode.asciiArtString())
        
        blueRectangle.style.preferredSize = CGSize(width: 200, height: self.view.frame.size.height)
        redRectangle.style.preferredSize = CGSize(width: 200, height: 200)
        
        
        initialNode.backgroundColor = UIColor.white
        blueRectangle.backgroundColor = UIColor.blue
        redRectangle.backgroundColor = UIColor.red
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Switch", style: .plain, target: self, action: #selector(switchRectangle(_: )))
        
    }
    
    func switchRectangle(_: Any) {
        switch rectangleState {
        case .blue:
            rectangleState = .red
            self.initialNode.transitionLayout(withAnimation: true, shouldMeasureAsync: true)
        case .red:
            rectangleState = .blue
            self.initialNode.transitionLayout(withAnimation: true, shouldMeasureAsync: true)

        }
    }
    
    
}

