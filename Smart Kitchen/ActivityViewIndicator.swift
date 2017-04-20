//
//  HandleActivityViewController.swift
//  Vitop
//
//  Created by Navdeesh Ahuja on 26/01/17.
//  Copyright © 2017 Navdeesh Ahuja. All rights reserved.
//
import UIKit

class ActivityViewIndicator
{
    static var activityViewIndicator = UIActivityIndicatorView()
    static var label = UILabel()

    static func show(_ view:UIView, _ message:String, _ size:CGFloat = 17)
    {
        activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityViewIndicator.startAnimating()
        activityViewIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activityViewIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.text = message
        label.font = label.font.withSize(size)
        label.sizeToFit()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.center = CGPoint(x: view.center.x, y: view.center.y + 36)
        view.addSubview(activityViewIndicator)
        view.addSubview(label)
        view.bringSubview(toFront: activityViewIndicator)
        view.bringSubview(toFront: label)
        
    }
    
    static func hide()
    {
        activityViewIndicator.stopAnimating()
        activityViewIndicator.removeFromSuperview()
        label.removeFromSuperview()
    }
    
}
