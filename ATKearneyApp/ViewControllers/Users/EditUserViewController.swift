//
//  EditUserViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 18/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit
import CropViewController


class EditUserViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {

    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var skillsTextField: UITextField!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var photoChanged = false
    var firstTime = true
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollview, bottomContraint: bottomConstraint)
        
        nameTextField.text! = MyUser.shared.name
        emailTextField.text! = MyUser.shared.email
        phoneTextField.text! = MyUser.shared.phone
        roleTextField.text = MyUser.shared.role
        skillsTextField.text = MyUser.shared.skills
        
        emailTextField.isEnabled = false
        photoButton.setCircularWithRadius(35.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(firstTime) {
            FirebaseManager.shared.userPhoto(userID: MyUser.shared.userID,
                                             lastUpdate: MyUser.shared.photoLastUpdate, to: photoButton)
            firstTime = false
        }
    }
    
    // MARK: - Button actions
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        showLoading(true)
        saveStep2()
        /*
        if(MyUser.shared.email != emailTextField.text!) {
            FirebaseManager.shared.editUserEmail(email: emailTextField.text!) { (error) in
                if(error != nil) {
                    print( error?.localizedDescription )
                    
                    var text = ""
                    let errorCode = ERROR_CODE(error)
                    
                    switch(errorCode) {
                    case 17011, 17009:
                        text = text_LOGIN_ERROR
                    case 17008:
                        text = text_INVALID_EMAIL
                    default:
                        text = text_GENERIC_ERROR
                    }
                    ALERT(title_ERROR, text, viewController: self)
                } else {
                    print("go!")
                }
                
                self.showLoading(false)
            }
        } else {
            //saveStep2()
            print("go!")
            self.showLoading(false)
        }
 */
    }
    
    func saveStep2() {
        let info = [
            "admin": MyUser.shared.admin,
            "name": nameTextField.text!,
            "email": emailTextField.text!,
            "phone": phoneTextField.text!,
            "role": roleTextField.text!,
            "skills": skillsTextField.text!,
            "photoLastUpdate": MyUser.shared.photoLastUpdate as Any
            ] as [String : Any]
        
        FirebaseManager.shared.editUser(userID: MyUser.shared.userID, info: info){ (error) in
            if(error==nil) {
                let info = [
                    "admin": MyUser.shared.admin,
                    "name": self.nameTextField.text!,
                    "email": self.emailTextField.text!,
                    "phone": self.phoneTextField.text!,
                    "role": self.roleTextField.text as Any,
                    "skills": self.skillsTextField.text as Any,
                    "photoLastUpdate": MyUser.shared.photoLastUpdate as Any
                    ] as [String: Any]
                
                MyUser.shared.fillWith(userID: MyUser.shared.userID, info: info)
                SelectedUser.shared = MyUser.shared
                
                if(self.photoChanged) {
                    let time = NOW()
                    FirebaseManager.shared.uploadUserPhoto(userID: MyUser.shared.userID, photo: self.photoButton.imageView!.image!, time: time) { (error) in
                        if(error != nil) {
                            ALERT(title_ERROR, text_ERROR_PHOTO_SAVE, viewController: self)
                        }
                        
                        MyUser.shared.photoLastUpdate = time
                        SelectedUser.shared = MyUser.shared
                        
                        self.showLoading(false)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showLoading(false)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
            }
        }
    }
    
    @IBAction func photoButtonTap(_ sender: UIButton) {
        let text = "Profile photo change"
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Take photo", style: .default) { (alertAction) in
            self.takePhoto()
        }
        let libAction = UIAlertAction(title: "Select from library", style: .default) { (alertAction) in
            self.selectImageFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(photoAction)
        alert.addAction(libAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) {
        }
    }
    
    // MARK: - Photo & images
    func takePhoto() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if(PERMISSIONS_FOR_CAMERA()) {
                let picker = UIImagePickerController()
                picker.allowsEditing = false
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                
                picker.delegate = self
                self.present(picker, animated: true)
            } else {
                ALERT(title_ERROR, text_NO_PERMISSIONS, viewController: self)
            }
        } else {
            ALERT(title_ERROR, text_NO_CAMERA, viewController: self)
        }
    }
    
    func selectImageFromLibrary() {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            
            picker.delegate = self
            self.present(picker, animated: true)
        } else {
            ALERT(title_ERROR, text_NO_CAMERA, viewController: self)
        }
    }
    
    // MARK: - UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: false, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.presentCropViewController(image: image)
    }
    
    // MARK: - CropViewController
    func presentCropViewController(image: UIImage) {
        
        let cropViewController: CropViewController
        cropViewController = CropViewController(croppingStyle: .circular, image: image)
        cropViewController.title = "Profile photo"
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.dismiss(animated: true, completion: nil)
        
        photoButton.setImage(image, for: .normal)
        photoChanged = true
    }
    
    
}


