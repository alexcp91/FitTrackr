//
//  MapNode.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/19/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import MapKit

class MapNode: ASDisplayNode {
  
  var mapView: MKMapView!
  var node: ASDisplayNode!
  
  
    
  override init() {
    self.mapView = MKMapView()
    super.init()

    node = ASDisplayNode(viewBlock: { () -> MKMapView in
      let view = self.mapView
      return view!
    })
    
    automaticallyManagesSubnodes = true
    
    
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    
    
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    let height = constrainedSize.max.height
    let width = constrainedSize.max.width
    
    node.style.preferredSize = CGSize(width: width, height: height)
    
    return ASInsetLayoutSpec(insets: insets, child: node)
    
  }
  
}

