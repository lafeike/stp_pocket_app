//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit
import MarkupKit

class ___FILEBASENAMEASIDENTIFIER___: LMCollectionViewCell {
    // TODO: Define outlets or model properties for view elements

    override init(frame: CGRect) {
        super.init(frame: frame)

        LMViewBuilder.view(withName:"___FILEBASENAMEASIDENTIFIER___", owner: self, root: self)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    deinit {
        unbindAll()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // TODO: Clear contents
    }
}
