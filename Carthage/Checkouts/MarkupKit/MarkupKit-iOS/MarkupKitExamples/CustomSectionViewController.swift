//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import MarkupKit

class CustomSectionViewController: LMTableViewController {
    let dynamicSectionName = "dynamic"
    let cellIdentifier = "cell"

    override func loadView() {
        view = LMViewBuilder.view(withName: "CustomSectionViewController", owner: self, root: nil)

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Custom Section View"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let n: Int
        if (tableView.name(forSection: section) == dynamicSectionName) {
            n = 3
        } else {
            n = super.tableView(tableView, numberOfRowsInSection: section)
        }

        return n
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if (tableView.name(forSection: indexPath.section) == dynamicSectionName) {
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel!.text = String(indexPath.row + 1)
        } else {
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }

        return cell
    }

    #if os(iOS)
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (tableView.name(forSection: indexPath.section) == dynamicSectionName)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editActions: [UITableViewRowAction]
        if (tableView.name(forSection: indexPath.section) == dynamicSectionName) {
            editActions = [
                UITableViewRowAction(style: .normal, title: "Select") { action, indexPath in
                    tableView.reloadRows(at: [indexPath], with: .right)

                    let alertController = UIAlertController(title: "Row Selected",
                        message: "You selected row \(indexPath.row + 1).",
                        preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))

                    self.present(alertController, animated: true)
                }
            ]
        } else {
            editActions = super.tableView(tableView, editActionsForRowAt: indexPath)!
        }

        return editActions
    }
    #endif
}
