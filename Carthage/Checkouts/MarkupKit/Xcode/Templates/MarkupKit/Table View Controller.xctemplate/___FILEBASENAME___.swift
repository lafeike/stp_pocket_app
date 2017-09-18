//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit
import MarkupKit

class ___FILEBASENAMEASIDENTIFIER___: LMTableViewController {
    deinit {
        unbindAll()
    }

    override func loadView() {
        view = LMViewBuilder.view(withName:"___FILEBASENAMEASIDENTIFIER___", owner: self, root: nil)

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Perform any post-load configuration
    }
}
