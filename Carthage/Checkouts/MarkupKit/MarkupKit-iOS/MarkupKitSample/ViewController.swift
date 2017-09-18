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

/**
 * Table view controller.
 */
class ViewController: LMTableViewController {
    // Outlets
    @IBOutlet var textField1: UITextField!
    @IBOutlet var textField2: UITextField!
    @IBOutlet var footerSwitch: UISwitch!

    // Properties
    var rows: [Row]!

    let dynamicSectionName = "dynamic"

    // View initialization
    override func loadView() {
        view = LMViewBuilder.view(withName: "ViewController", owner: self, root: nil)

        // Configure table view
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Bundle.main.localizedString(forKey: "title", value: nil, table: nil)

        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.description())

        // Load row list
        let jsonDecoder = JSONDecoder()

        rows = try! jsonDecoder.decode([Row].self, from: try! Data(contentsOf: Bundle.main.url(forResource: "rows", withExtension: "json")!))
    }

    // Button press handler
    @IBAction func buttonPressed() {
        let alertController = UIAlertController(title: Bundle.main.localizedString(forKey: "alert", value: nil, table: nil),
            message: Bundle.main.localizedString(forKey: "message", value: nil, table: nil),
            preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: Bundle.main.localizedString(forKey: "ok", value: nil, table: nil),
            style: .default))

        present(alertController, animated: true)
    }

    // Data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let n: Int
        if (tableView.name(forSection: section) == dynamicSectionName) {
            n = rows.count
        } else {
            n = super.tableView(tableView, numberOfRowsInSection: section)
        }

        return n
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if (tableView.name(forSection: indexPath.section) == dynamicSectionName) {
            let customCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.description(), for: indexPath) as! CustomCell

            customCell.row = rows[indexPath.row]

            cell = customCell
        } else {
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }

        return cell
    }

    // Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.name(forSection: indexPath.section) == dynamicSectionName) {
            let row = rows[indexPath.row]

            let detailViewController = DetailViewController()

            detailViewController.loadView()

            detailViewController.headingLabel.text = row.heading
            detailViewController.detailLabel.text = row.detail

            present(detailViewController, animated: true)
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
}

