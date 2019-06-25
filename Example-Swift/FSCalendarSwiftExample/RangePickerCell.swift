//
//  RangePickerCell.swift
//  FSCalendarSwiftExample
//
//  Created by Hussein Habibi Juybari on 5/13/18.
//  Copyright © 2018 wenchao. All rights reserved.
//

import UIKit

class RangePickerCell: FSCalendarCell {
    
    public var middleLayer : CALayer = CALayer();
    public var selectionLayer : CALayer = CALayer();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionLayer = CALayer()
        selectionLayer.backgroundColor = UIColor.orange.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        // Remove hiding animation
        contentView.layer.insertSublayer(selectionLayer, below: titleLabel?.layer)
        self.selectionLayer = selectionLayer
        let middleLayer = CALayer()
        middleLayer.backgroundColor = UIColor.orange.withAlphaComponent(0.3).cgColor
        middleLayer.actions = ["hidden": NSNull()]
        // Remove hiding animation
        contentView.layer.insertSublayer(middleLayer, below: titleLabel?.layer)
        self.middleLayer = middleLayer
        // Hide the default selection layer
        shapeLayer.isHidden = true
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame = contentView.bounds
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        middleLayer.frame = contentView.bounds
        selectionLayer.frame = contentView.bounds
    }
}
