//
//  MasterSplitViewController.swift
//  Pokédex 2
//
//  Created by Ben Burford on 23/09/2016.
//  Copyright © 2016 Ben Burford. All rights reserved.
//

import Foundation
import UIKit

class MasterSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
