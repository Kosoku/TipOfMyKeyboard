//
//  TableViewController.swift
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

protocol DetailViewController {
    var name: String { get }
    var summary: String? { get }
}

class TableViewController: UITableViewController {
    private let detailViewControllers: [UIViewController & DetailViewController] = [SelfSizingCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tip of My Keyboard"
        
        self.tableView.backgroundColor = .white
        self.tableView.register(KDITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailViewControllers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let retval = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KDITableViewCell
        
        retval.accessoryType = .disclosureIndicator
        retval.title = self.detailViewControllers[indexPath.row].name
        retval.subtitleNumberOfLines = 0
        retval.subtitle = self.detailViewControllers[indexPath.row].summary
        
        return retval
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(self.detailViewControllers[indexPath.row], animated: true)
    }
}
