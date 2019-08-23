//
//  NavigationBarTintColorUpdating.swift
//  TipOfMyKeyboard
//
//  Created by William Towe on 8/22/19.
//  Copyright © 2019 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Ditko
import KSOColorPicker

extension UINavigationController {
    func updateNavigationBarTintColor(_ barTintColor: UIColor) {
        let block = {
            self.navigationBar.barTintColor = barTintColor
            self.navigationBar.tintColor = barTintColor.kdi_contrasting().kdi_colorByAdjustingBrightness(byPercent: -0.15)!
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: barTintColor.kdi_contrasting()]
            
            if self is StatusBarUpdatingNavigationController {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
        
        guard let transitionCoordinator = self.transitionCoordinator else {
            block()
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: { _ in
            block()
        }, completion: { context in
            // the interactive animation was cancelled, call the block again
            if context.isCancelled {
                block()
            }
        })
    }
}

class StatusBarUpdatingNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.navigationBar.barTintColor?.kdi_contrastingStatusBarStyle() ?? .default
    }
}

class NavigationBarTintColorUpdatingViewController: UIViewController, DetailViewController {
    private let stackView = UIStackView()
    private let pushBarTintColorButton = KSOColorPickerButton(type: .system)
    private let popBarTintColorButton = KSOColorPickerButton(type: .system)
    
    var name: String {
        return "UINavigationBar barTintColor updating"
    }
    var summary: String? {
        return "Animating the transition between barTintColor changes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.name
        self.view.backgroundColor = .white
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.alignment = .center
        self.stackView.spacing = 8.0
        self.view.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
        
        self.pushBarTintColorButton.translatesAutoresizingMaskIntoConstraints = false
        self.pushBarTintColorButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        self.pushBarTintColorButton.setTitle("Push Color", for: .normal)
        self.stackView.addArrangedSubview(self.pushBarTintColorButton)
        
        self.popBarTintColorButton.translatesAutoresizingMaskIntoConstraints = false
        self.popBarTintColorButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        self.popBarTintColorButton.setTitle("Pop Color", for: .normal)
        self.stackView.addArrangedSubview(self.popBarTintColorButton)
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        // this handles the more common, non-interactive animation case
        guard let color = parent == nil ? self.popBarTintColorButton.color : self.pushBarTintColorButton.color else {
            return
        }
        
        self.navigationController?.updateNavigationBarTintColor(color)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // this handles the case where the interactive pop animation is cancelled, so we reset to the push color
        guard let color = self.pushBarTintColorButton.color else {
            return
        }
        
        self.navigationController?.updateNavigationBarTintColor(color)
    }
}
