//
//  PopUpViewController.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/19/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import Foundation
import UIKit

class PopUpViewController: UIViewController {
  
  var modalView: UIView!
  
  override func viewDidLoad() {
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    self.view.isOpaque = false
    
    modalView = UIView()
    modalView.frame = CGRect(x: 150, y: 150, width: 300, height: 300)
    modalView.backgroundColor = UIColor.blue
    self.view.addSubview(modalView)
    
    showAnimate()

    
  }
  
  
  func showAnimate()
  {
    self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    self.view.alpha = 0.0
    UIView.animate(withDuration: 0.25, animations: {
      self.view.alpha = 0.2
      self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    })
  }
  
  
}
