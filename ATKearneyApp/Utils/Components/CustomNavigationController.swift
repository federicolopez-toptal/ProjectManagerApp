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
        
        let centeredView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        centeredView.center = loadingView.center
        centeredView.backgroundColor = UIColor.white
        centeredView.layer.cornerRadius = 10.0
        loadingView.addSubview(centeredView)
        
        let loading = UIActivityIndicatorView(style: .gray)
        loading.color = UIColor.black
        loading.startAnimating()
        centeredView.addSubview(loading)
        loading.center = CGPoint(x: centeredView.frame.size.width/2, y: centeredView.frame.size.height/2)
    }
    
    func showLoading(_ visibility: Bool) {
        loadingView.isHidden = !visibility
    }

}
