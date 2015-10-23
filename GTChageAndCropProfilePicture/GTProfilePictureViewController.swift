//
//  GTProfilePictureViewController.swift
//  ZoomAndCropImage
//
//  Created by Pankti Patel on 15/07/15.
//  Copyright (c) 2015 Pankti Patel. All rights reserved.
//

import UIKit

public class GTProfilePictureViewController: NSObject,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var addPhotoButton: UIButton!
    //let  kPhotoDiameter: CGFloat = 130.0
    var  didSetupConstraints:Bool?
    var imagePicker:UIImagePickerController!
    
    var calledViewController:UIViewController!
    var delegate:GTProfilePictureDelegate!
    var imageCropMode:SMUImageCropMode = SMUImageCropMode.Circle
    
    public func setDelegate(delegate:GTProfilePictureDelegate!)
    {
        self.delegate = delegate
    }
    
    class public func sharedInstance() -> GTProfilePictureViewController {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : GTProfilePictureViewController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = GTProfilePictureViewController()
            Static.instance?.imagePicker = UIImagePickerController()
        }
        return Static.instance!
    }
    
    public func changeProfilePicture(viewController:UIViewController)
    {
        self.calledViewController = viewController
        
        let pictureSelectionOptionsMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let openGalleryAction = UIAlertAction(title: "Open Gallery", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "photoRecieved:", name:"photoRecieved", object: nil)
            self.calledViewController.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let openCameraAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .Camera
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "photoRecieved:", name:"photoRecieved", object: nil)
                self.calledViewController.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: nil, message: "Camera not supported", preferredStyle: UIAlertControllerStyle.Alert)
                let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    
                })
               alert.addAction(OkAction)
                self.calledViewController.presentViewController(alert, animated: true, completion: nil)
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        pictureSelectionOptionsMenu.addAction(openGalleryAction)
        pictureSelectionOptionsMenu.addAction(openCameraAction)
        pictureSelectionOptionsMenu.addAction(cancelAction)
        
        self.calledViewController.presentViewController(pictureSelectionOptionsMenu, animated: true, completion: nil)
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.calledViewController.dismissViewControllerAnimated(false, completion: nil)
        let photo:UIImage = image
        let imageVC:GTImageCropViewController = GTImageCropViewController()
        imageVC.initWithImage(originalImage: photo, cropMode: imageCropMode)
        self.calledViewController.navigationController?.pushViewController(imageVC, animated: true)
    }
    
    func photoRecieved(notification: NSNotification){
        let userInfo : Dictionary<String,UIImage> = notification.userInfo as! Dictionary<String,UIImage>
        if !userInfo.isEmpty{
            self.delegate.changeProfileImageCallBack(userInfo["image"]!)
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        self.calledViewController.navigationController!.popViewControllerAnimated(true)
    }


}

