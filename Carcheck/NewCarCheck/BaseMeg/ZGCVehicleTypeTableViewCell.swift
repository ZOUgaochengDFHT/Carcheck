//
//  ZGCVehicleTypeTableViewCell.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/24.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCVehicleTypeTableViewCell: UITableViewCell {

    var carBrandListModel :ZGCCarBrandModel!
    var tapToVehicleTypeVCHandler: TapToVehicleTypeVCBlock!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: "tapToVehicleTypeVC:")
        self.contentView.addGestureRecognizer(tap)
    }
    
    func tapToVehicleTypeVC(tap:UITapGestureRecognizer) {
        tapToVehicleTypeVCHandler(carBrandListModel: carBrandListModel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
