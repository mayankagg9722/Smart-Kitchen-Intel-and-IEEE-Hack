//
//  ErrorWindow.swift
//  Vitop
//
//  Created by Navdeesh Ahuja on 27/01/17.
//  Copyright © 2017 Navdeesh Ahuja. All rights reserved.
//

import UIKit

class ErrorWindow
{
    static var errorImageView:UIImageView = UIImageView()
    static var overlayView:UIView = UIView()
    static let okayButtonImage = UIImage(named: "errorSubmitButton")
    static let okaybutton:UIButton = UIButton(type: UIButtonType.custom)
    
    
    static func show(_ view:UIView, _ imageName:String)
    {
        overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.5
        
        errorImageView = UIImageView(frame: CGRect(x: 0, y: view.frame.height, width: 0.9*view.frame.width, height: 0.9*view.frame.width))
        errorImageView.image = UIImage(named: imageName)
        errorImageView.center = view.center
        
        let okayButtonHeight = 0.9*view.frame.width*0.171
        okaybutton.addTarget(self, action: #selector(ErrorWindow.hide), for: .touchUpInside)
        okaybutton.frame = CGRect(x: 0.05*view.frame.width, y: errorImageView.frame.maxY - okayButtonHeight, width:0.9*view.frame.width, height:okayButtonHeight)
        okaybutton.setImage(okayButtonImage, for: .normal)
        
        view.addSubview(overlayView)
        view.addSubview(errorImageView)
        view.addSubview(okaybutton)
        view.bringSubview(toFront: overlayView)
        view.bringSubview(toFront: errorImageView)
        view.bringSubview(toFront: okaybutton)
    }
    
    @objc static func hide()
    {
        overlayView.removeFromSuperview()
        errorImageView.removeFromSuperview()
        okaybutton.removeFromSuperview()
    }
    
}
