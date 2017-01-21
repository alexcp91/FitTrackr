//
//  PopUpViewController.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/19/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import Foundation
import UIKit

class PopUpViewController: UIViewController, Dismissable {
    
    weak var dismissalDelegate: DismissalDelegate?
    var modalView: UIView!
    var dismissButton: UIButton!
    
    func dismissButtonTapped(_: Any) {
    dismissalDelegate?.finishedShowing(viewController: self)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isOpaque = false
        
        modalView = UIView()
        
                let modalSize:[CGFloat] = [200, 200]
        let containerLeftMargin = (self.view.bounds.width - modalSize[0]) / 2
        let containerTopMargin = (self.view.bounds.height - modalSize[1]) / 2
        
        modalView.frame = CGRect(x: containerLeftMargin, y: containerTopMargin, width: modalSize[0], height: modalSize[1])
        modalView.backgroundColor = UIColor.blue
        self.view.addSubview(modalView)
        
        dismissButton = UIButton()
        
        
        var buttonContainer = modalView.frame.size
        print(buttonContainer)
        var buttonSize: [CGFloat] = [150, 50]
        
        var left_margin = (buttonContainer.width - buttonSize[0]) / 2
        
        var top_margin = (buttonContainer.height - buttonSize[1]) / 2
        dismissButton.frame = CGRect(x: left_margin, y: top_margin, width: buttonSize[0], height: buttonSize[1])
        dismissButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
        dismissButton.setTitle("Close", for: [ ])
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        
        
        
        modalView.addSubview(dismissButton)
        
        // showAnimate()
        
        
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
