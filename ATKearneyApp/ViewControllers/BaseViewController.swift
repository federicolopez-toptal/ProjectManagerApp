//
//  BaseViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 13/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private var formMode = false
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Form behavior stuff
    func addFormBehavior(scrollview: UIScrollView, bottomContraint: NSLayoutConstraint) {
        formMode = true
        scrollViewBottomConstraint = bottomContraint
        scrollview.contentInsetAdjustmentBehavior = .never
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(sender:)))
        scrollview.subviews.first?.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(formMode){
            addKeyboardObservers()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(formMode){
            removeKeyboardObservers()
        }
    }
    
    // MARK: - Gesture(s)
    @objc func viewOnTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Keyboard management
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent(n:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent(n:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardEvent(n: Notification) {
        let H = getKeyboardHeight(fromNotification: n)
        
        if(n.name==UIResponder.keyboardWillShowNotification){
            scrollViewBottomConstraint!.constant = H
        } else if(n.name==UIResponder.keyboardWillHideNotification) {
            scrollViewBottomConstraint!.constant = 0
        }
        
        view.layoutIfNeeded()
    }
    
    func getKeyboardHeight(fromNotification notification: Notification) -> CGFloat {
        if let H = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            return H
        } else {
            return 300
        }
    }
    
}
