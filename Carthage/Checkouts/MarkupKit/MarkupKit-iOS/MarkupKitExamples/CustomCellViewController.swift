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

class CustomCellViewController: UITableViewController {
    var pharmacies: [[String: Any]]!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Custom Cell View"
        
        // Configure table view
        tableView.register(PharmacyCell.self, forCellReuseIdentifier: PharmacyCell.description())
        tableView.estimatedRowHeight = 2

        // Load pharmacy list
        let pharmacyListURL = Bundle.main.url(forResource: "pharmacies", withExtension: "json")

        pharmacies = try! JSONSerialization.jsonObject(with: try! Data(contentsOf: pharmacyListURL!)) as! [[String: Any]]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pharmacies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get pharmacy data
        let index = indexPath.row
        
        let pharmacy = pharmacies[index]

        // Configure cell with pharmacy data
        let cell = tableView.dequeueReusableCell(withIdentifier: PharmacyCell.description(), for: indexPath) as! PharmacyCell

        cell.name = String(format: "%d. %@", index + 1, pharmacy["name"] as! String)

        cell.distance = String(format: "%.2f miles", pharmacy["distance"] as! Double)

        cell.address = String(format: "%@\n%@ %@ %@",
            pharmacy["address1"] as! String,
            pharmacy["city"] as! String, pharmacy["state"] as! String,
            pharmacy["zipCode"] as! String)

        let phoneNumberFormatter = PhoneNumberFormatter()

        let phone = pharmacy["phone"] as? String
        cell.phone = (phone == nil) ? nil : phoneNumberFormatter.string(for: phone!)

        let fax = pharmacy["fax"] as? String
        cell.fax = (fax == nil) ? nil : phoneNumberFormatter.string(for: fax!)

        cell.email = pharmacy["email"] as? String

        return cell
    }
}

class PhoneNumberFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        let val = obj as! NSString

        return String(format: "(%@) %@-%@",
            val.substring(with: NSMakeRange(0, 3)),
            val.substring(with: NSMakeRange(3, 3)),
            val.substring(with: NSMakeRange(6, 4))
        )
    }
}
