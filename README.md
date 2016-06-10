# GTChageAndCropProfilePicture
This framework will allow you to change profile picture using camera roll or you can pic picture from gallery.

USAGE:

1. You can import this framework using pods. Use 
    pod 'GTChageAndCropProfilePicture', :git => 'https://github.com/RakeshKoplodR/GTChageAndCropProfilePicture.git'

2. Confirm to the GTProfilePictureDelegate protocol in your ViewController.

3. Add action to the UIImageView or Button. Copy the below code in that action method.
    GTProfilePictureViewController.sharedInstance().changeProfilePicture(self)
    GTProfilePictureViewController.sharedInstance().setDelegate(self)

4. That's all, You will Image object in callback.
    func changeProfileImageCallBack(image: UIImage) {
        
    }
