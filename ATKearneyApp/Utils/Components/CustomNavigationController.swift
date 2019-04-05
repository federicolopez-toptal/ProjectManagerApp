//
//  CustomNavigationController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 19/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    let loadingView = UIView()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        createLoading()
        showLoading(false)
    }
    
    // MARK: - Loading
    private func createLoading() {
        loadingView.frame = self.view.frame
        loadingView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.45)
        self.view.addSubview(loadingView)
        
        let centeredView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        centeredView.center = loadingView.center
        centeredView.backgroundColor = UIColor.white
        centeredView.layer.cornerRadius = 10.0
        loadingView.addSubview(centeredView)
        
        let loading = UIActivityIndicatorView(style: .gray)
        loading.color = UIColor.black
        loading.startAnimating()
        centeredView.addSubview(loading)
        
        var mFrame = loading.frame
        mFrame.origin.x = (centeredView.frame.width - 20)/2
        mFrame.origin.y = 20
        loading.frame = mFrame
        
        let label = UILabel(frame: CGRect(x: 0, y: BOTTOM(view: loading) + 20, width: centeredView.frame.width, height: 1))
        label.font = UIFont(name: "Graphik-Regular", size: 14)
        label.textAlignment = .center
        CHANGE_LABEL_HEIGHT(label: label, text: "Loading...")
        centeredView.addSubview(label)
    }
    
    func showLoading(_ visibility: Bool) {
        loadingView.isHidden = !visibility
    }

}
