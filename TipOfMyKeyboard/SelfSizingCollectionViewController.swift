//
//  SelfSizingCollectionViewController.swift
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
import LoremIpsum

extension NSLayoutConstraint.FormatOptions {
    static let none: NSLayoutConstraint.FormatOptions = []
}

class SectionHeaderFooter: UICollectionReusableView {
    public static let shared = SectionHeaderFooter()
    
    private let titleLabel = UILabel()
    
    var requiredWidth: CGFloat?
    var title: String? {
        get {
            return self.titleLabel.text
        }
        set(value) {
            self.titleLabel.text = value
        }
    }
    var titleColor: UIColor {
        get {
            return self.titleLabel.textColor
        }
        set(value) {
            self.titleLabel.textColor = value
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let retval = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        if let width = self.requiredWidth {
            let size = self.systemLayoutSizeFitting(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            
            retval.frame.size = CGSize(width: width, height: ceil(size.height))
        }
        
        return retval
    }
    
    private func setup() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.addSubview(self.titleLabel)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view]-|", options: .none, metrics: nil, views: ["view": self.titleLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view]-|", options: .none, metrics: nil, views: ["view": self.titleLabel]))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
}

class CollectionViewCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    
    var requiredWidth: CGFloat?
    var title: String? {
        get {
            return self.titleLabel.text
        }
        set(value) {
            self.titleLabel.text = value
        }
    }
    var titleColor: UIColor {
        get {
            return self.titleLabel.textColor
        }
        set(value) {
            self.titleLabel.textColor = value
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let retval = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        if let width = self.requiredWidth {
            let size = self.contentView.systemLayoutSizeFitting(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            
            retval.frame.size = CGSize(width: width, height: ceil(size.height))
        }
        
        return retval
    }
    
    private func setup() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.contentView.addSubview(self.titleLabel)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view]-|", options: .none, metrics: nil, views: ["view": self.titleLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view]-|", options: .none, metrics: nil, views: ["view": self.titleLabel]))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
}

class SelfSizingCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DetailViewController {
    private let sections: [[String]] = (0...5).map { _ in
        return (0...5).map { _ in
            return LoremIpsum.sentence()
        }
    }
    
    override var collectionViewLayout: UICollectionViewFlowLayout {
        return super.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    var name: String {
        return "Self sizing UICollectionView"
    }
    var summary: String? {
        return "UICollectionView with self sizing cells and supplementary views"
    }
    
    private func requiredWidthForSection(_ section: Int) -> CGFloat {
        return self.collectionView.frame.width - self.collectionViewLayout.sectionInset.left - self.collectionViewLayout.sectionInset.right
    }
    private func requiredWidthForCellAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        var availableWidth = self.collectionView.frame.width
        
        availableWidth -= self.collectionViewLayout.sectionInset.left
        availableWidth -= self.collectionViewLayout.sectionInset.right
        
        return floor(availableWidth / CGFloat(indexPath.section + 1))
    }
    private func configureSectionHeaderFooter(_ view: SectionHeaderFooter, for section: Int) {
        view.requiredWidth = self.requiredWidthForSection(section)
        view.title = self.sections[section].first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.name
        
        self.collectionView.backgroundColor = .white
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SectionHeaderFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView.register(SectionHeaderFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let retval = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind == UICollectionView.elementKindSectionHeader ? "header" : "footer", for: indexPath) as! SectionHeaderFooter
        
        self.configureSectionHeaderFooter(retval, for: indexPath.section)
        
        return retval
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let retval = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        retval.requiredWidth = self.requiredWidthForCellAtIndexPath(indexPath)
        retval.title = self.sections[indexPath.section][indexPath.item]
        
        return retval
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let view = view as! SectionHeaderFooter
        let color = UIColor.kdi_colorRandomRGB
        
        view.backgroundColor = color
        view.titleColor = color.kdi_contrasting()
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! CollectionViewCell
        let color = UIColor.kdi_colorRandomRGB
        
        cell.backgroundColor = color
        cell.titleColor = color.kdi_contrasting()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        self.configureSectionHeaderFooter(SectionHeaderFooter.shared, for: section)
        
        return SectionHeaderFooter.shared.preferredLayoutAttributesFitting(UICollectionViewLayoutAttributes()).frame.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        self.configureSectionHeaderFooter(SectionHeaderFooter.shared, for: section)
        
        return SectionHeaderFooter.shared.preferredLayoutAttributesFitting(UICollectionViewLayoutAttributes()).frame.size
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.headerReferenceSize = UICollectionViewFlowLayout.automaticSize
        layout.footerReferenceSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        super.init(collectionViewLayout: layout)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
