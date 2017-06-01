//
//  ControllerViewDesign.swift
//
//  Created by Saoud Rizwan on 6/1/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit

class ControllerView: UIView {
    
    weak var controller: Controller?
    
    init(controller: Controller) {
        super.init(frame: controller.view.frame)
        controller.view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: controller.view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: controller.view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: controller.view.rightAnchor).isActive = true
        self.backgroundColor = UIColor.white
        self.controller = controller
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func layoutViews() { }
}

protocol ControllerDelegate: class {
    weak var controllerView: ControllerView? { get set }
}

class Controller: UIViewController, ControllerDelegate {
    weak var controllerView: ControllerView? {
        didSet {
            self.setViewHandlers()
        }
    }
    
    func setViewHandlers() { }
}
https://github.com/saoudrizwan/ControllerViewDesign.git
