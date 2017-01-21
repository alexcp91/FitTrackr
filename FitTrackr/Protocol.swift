//
//  Protocol.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/20/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import UIKit

protocol DismissalDelegate : class
{
    func finishedShowing(viewController: UIViewController);
}

protocol Dismissable : class
{
    weak var dismissalDelegate : DismissalDelegate? { get set }
}

extension DismissalDelegate where Self: UIViewController
{
    func finishedShowing(viewController: UIViewController) {
        if let vc = viewController as? Dismissable {
            dismiss(animated: true, completion: nil)            
    }
}
}
