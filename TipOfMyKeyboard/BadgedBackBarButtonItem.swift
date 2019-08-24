//
//  BadgedBackBarButtonItem.swift
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

import Agamotto
import Ditko
import KSOColorPicker
import Stanley

class BadgedBackBarButtonItemViewController: UIViewController, DetailViewController {
    private let stackView = UIStackView()
    private let updateButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    private let tintColorButton = KSOColorPickerButton(type: .system)
    
    var name: String {
        return "Badged backBarButtonItem"
    }
    var summary: String? {
        return "Badging the backBarButtonItem similar to Mail app"
    }
    
    private func updateBackBarButtonItem(_ backBarButtonItem: UIBarButtonItem?) {
        // this is the important part, you must set the backBarButtonItem on the previous view controller in the stack, not the current view controller
        self.navigationController?.viewControllers.first?.navigationItem.backBarButtonItem = backBarButtonItem
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
        
        self.updateButton.translatesAutoresizingMaskIntoConstraints = false
        self.updateButton.setTitle("Update Badge Count", for: .normal)
        self.updateButton.kdi_add({ [weak self] (_, _) in
            let count = arc4random_uniform(1000)
            let string = NumberFormatter.localizedString(from: NSNumber(value: count), number: .decimal) as NSString
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white]
            let size = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).integral.size
            let rect = CGRect(x: 0.0, y: 0.0, width: size.width + 8.0, height: size.height + 4.0)
            
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            
            // draw our tintable background first
            UIColor.black.setFill()
            UIBezierPath(roundedRect: rect, cornerRadius: 4.0).fill()
            
            let context = UIGraphicsGetCurrentContext()!
            
            context.saveGState()
            // set the appropriate blend mode so the text will "punch out" the background color
            context.setBlendMode(.destinationOut)
            
            // draw out text
            string.draw(in: KSTCGRectCenterInRect(CGRect(origin: .zero, size: size), rect), withAttributes: attributes)
            
            context.restoreGState()
            
            // get the image as a template, so the tintColor from the navigation bar will always be applied
            let image = UIGraphicsGetImageFromCurrentImageContext()?.kdi_template
            
            UIGraphicsEndImageContext()
            
            // this is important, create a new back bar button item each time with the new image, just setting a new image on the existing item won't work
            let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
            
            self?.updateBackBarButtonItem(backBarButtonItem)
        }, for: .touchUpInside)
        self.stackView.addArrangedSubview(self.updateButton)
        
        self.clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton.setTitle("Clear Badge Count", for: .normal)
        self.clearButton.kdi_add({ [weak self] (_, _) in
            self?.updateBackBarButtonItem(nil)
        }, for: .touchUpInside)
        self.stackView.addArrangedSubview(self.clearButton)
        
        self.tintColorButton.translatesAutoresizingMaskIntoConstraints = false
        self.tintColorButton.setTitle("Tint Color", for: .normal)
        self.tintColorButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        self.stackView.addArrangedSubview(self.tintColorButton)
        
        self.tintColorButton.kag_addObserver(forKeyPath: "color", options: NSKeyValueObservingOptions(rawValue: 0)) { [weak self] (_, _, _) in
            self?.navigationController?.navigationBar.tintColor = self?.tintColorButton.color
        }
    }
}
