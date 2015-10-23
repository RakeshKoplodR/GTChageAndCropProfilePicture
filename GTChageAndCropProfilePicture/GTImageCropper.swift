//
//  GTImageCropper.swift
//  ZoomAndCropImage
//
//  Created by Pankti Patel on 15/07/15.
//  Copyright (c) 2015 Pankti Patel. All rights reserved.
//

import Foundation
import CoreGraphics
import Darwin

public struct SMULineSegment {
    var start:CGPoint;
    var end:CGPoint;
}

public class GTImageCropper {
    
    static let sharedInstance = GTImageCropper()

    let SMUPointNull:CGPoint =  CGPointZero

    func SMURectCenterPoint(rect:CGRect) -> CGPoint{
        
        return CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect)/2, CGRectGetMinY(rect) + CGRectGetHeight(rect) / 2)
        
    }
    
    func SMURectScaleAroundPoint (var rect :CGRect , point:CGPoint , sx:CGFloat, sy:CGFloat) -> CGRect{
        
        var translationTransform:CGAffineTransform?
        var scaleTransform:CGAffineTransform?
        rect = CGRectApplyAffineTransform(rect,translationTransform!)
        scaleTransform = CGAffineTransformMakeScale(sx, sy)
        rect = CGRectApplyAffineTransform(rect, scaleTransform!)
        translationTransform = CGAffineTransformMakeTranslation(point.x,point.y)
        rect = CGRectApplyAffineTransform(rect,translationTransform!)
        return rect
        
    }
    internal func SMUPointIsNull(point:CGPoint) -> Bool{
        
        return CGPointEqualToPoint(point, SMUPointNull)
    }
    
    func SMUPointRotateAroundPoint(var point:CGPoint , pivot:CGPoint,angle:CGFloat) -> CGPoint{
        
        var translationTransform:CGAffineTransform?
        var rotationTransform:CGAffineTransform?
        point = CGPointApplyAffineTransform(point, translationTransform!);
        rotationTransform = CGAffineTransformMakeRotation(angle);
        point = CGPointApplyAffineTransform(point, rotationTransform!);
        translationTransform = CGAffineTransformMakeTranslation(pivot.x, pivot.y);
        point = CGPointApplyAffineTransform(point, translationTransform!);
        return point;

        
     
    }
    func SMUPointDistance(p1:CGPoint , p2:CGPoint)-> CGFloat{
        
        let dx:CGFloat = p1.x - p2.x;
        let dy:CGFloat = p1.y - p2.y;
        return sqrt(pow(dx, 2) + pow(dy, 2));

        
    }
    func SMULineSegmentMake(start1:CGPoint , end1:CGPoint)-> SMULineSegment{
        
        return SMULineSegment(start: start1, end: end1)
    }
    
    func SMULineSegmentRotateAroundPoint(line:SMULineSegment , pivot:CGPoint , angle:CGFloat) -> SMULineSegment{
        
        return SMULineSegmentMake(SMUPointRotateAroundPoint(line.start, pivot: pivot, angle: angle), end1: SMUPointRotateAroundPoint(line.end, pivot: pivot, angle: angle))
        
    }
    
    func SMULineSegmentIntersection(ls1:SMULineSegment , ls2:SMULineSegment)-> CGPoint{
        
        let x1:CGFloat = ls1.start.x;
        let y1:CGFloat = ls1.start.y;
        let x2:CGFloat = ls1.end.x;
        let y2:CGFloat = ls1.end.y;
        let x3:CGFloat = ls2.start.x;
        let y3:CGFloat = ls2.start.y;
        let x4:CGFloat = ls2.end.x;
        let y4:CGFloat = ls2.end.y;

        let numeratorA:CGFloat = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3);
        let numeratorB:CGFloat = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3);
        let denominator:CGFloat = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);

        // Check the coincidence.
        if (fabs(numeratorA) < CGFloat(FLT_EPSILON) && fabs(numeratorB) < CGFloat(FLT_EPSILON) && fabs(denominator) < CGFloat(FLT_EPSILON)) {
            return CGPointMake((x1 + x2) * 0.5, (y1 + y2) * 0.5);
        }
        
        // Check the parallelism.
        if (fabs(denominator) < CGFloat(FLT_EPSILON)) {
            return SMUPointNull;
        }
        
        // Check the intersection.
        let uA:CGFloat = numeratorA / denominator;
        let uB:CGFloat = numeratorB / denominator;
        if (uA < 0 || uA > 1 || uB < 0 || uB > 1) {
            return SMUPointNull;
        }
        return CGPointMake(x1 + uA * (x2 - x1), y1 + uA * (y2 - y1));

    }
    
    
    
    
    
    
    
    
    
}