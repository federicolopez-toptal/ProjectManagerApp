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
    private var bottomConstraintConstant: CGFloat = 0.0
    
    private var reloadView: UIView?
    private var reloadCallback: Any?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Loading
    func showLoading(_ visibility: Bool) {
        self.view.endEditing(true)
        let navC = self.navigationController as! CustomNavigationController
        
        if(visibility) {
            if( INTERNET_AVAILABLE() ){
                navC.showLoading(true)
            } else {
                ALERT(title_ERROR, text_NO_INTERNET, viewController: self)
            }
        } else {
            navC.showLoading(false)
        }
    }
    
    // MARK: - Reload view
    func addReloadView(frame: CGRect, callback: @escaping () -> () ) {
        reloadCallback = callback
        
        reloadView = UIView(frame: frame)
        reloadView!.backgroundColor = UIColor.white
        self.view.addSubview(reloadView!)
        reloadView?.isHidden = true
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 35)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Reload", for: .normal)
        reloadView!.addSubview(button)
        button.center = reloadView!.center
        
        button.addTarget(self, action: #selector(reloadButtonTap), for: .touchUpInside)
    }
    
    func showReloadView() {
        reloadView?.isHidden = false
    }
    
    @objc func reloadButtonTap() {
        reloadView?.isHidden = true
        (reloadCallback as! () -> () )()
    }
    
    // MARK: - Form behavior stuff
    func addFormBehavior(scrollview: UIScrollView, bottomContraint: NSLayoutConstraint) {
        formMode = true
        scrollViewBottomConstraint = bottomContraint
        bottomConstraintConstant = bottomContraint.constant
        scrollview.contentInsetAdjustmentBehavior = .never
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(sender:)))
        scrollview.subviews.first?.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(formMode){
            addKeyboardObservers()
        } else {
            self.view.endEditing(true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        
        print(bottomConstraintConstant)
        if(n.name==UIResponder.keyboardWillShowNotification){
            scrollViewBottomConstraint!.constant = H
        } else if(n.name==UIResponder.keyboardWillHideNotification) {
            scrollViewBottomConstraint!.constant = bottomConstraintConstant
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
