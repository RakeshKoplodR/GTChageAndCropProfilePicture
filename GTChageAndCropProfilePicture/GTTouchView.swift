//
//  GTTouchView.swift
//  ZoomAndCropImage
//
//  Created by Pankti Patel on 15/07/15.
//  Copyright (c) 2015 Pankti Patel. All rights reserved.
//

import Foundation
import UIKit

public class GTTouchView: UIView {
    
    internal var receiver:UIView?
    
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if pointInside(point, withEvent: event){
            return receiver
        }
        return nil
    }
}