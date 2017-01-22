//
//  MaterialsCollectionViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import expanding_collection


class MaterialsCollectionViewCell: BasePageCollectionCell {

    @IBOutlet weak var materialName: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
      
    override func awakeFromNib() {
        super.awakeFromNib()
              // Initialization code
    }
    

}
