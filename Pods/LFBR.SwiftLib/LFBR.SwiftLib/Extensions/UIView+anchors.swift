//
//  UIView+anchors.swift
//  EasyAnchorsLBTA
//
//  Created by Brian Voong on 1/30/18.
//  Copyright © 2018 Lets Build That App. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// Adjust view constraints to fill superview with a padding
    ///
    /// - Parameter padding: padding space to superview
    func fillSuperview(padding: UIEdgeInsets) {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding)
    }
    
    /// Adjust view constraints to fill superview
    func fillSuperview() {
        fillSuperview(padding: .zero)
    }
    
    /// Equate the size of our view with the referenced view
    ///
    /// - Parameter view: reference view
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    /// Easy initialization of constraint of his view, with paddin and size
    ///
    /// - Parameters:
    ///   - top: top anchor
    ///   - leading: leading anchor
    ///   - bottom: bottom anchor
    ///   - trailing: trailing anchor
    ///   - padding: optional padding from anchor
    ///   - size: anchor size
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    /// Method to adjust width and height constraints equal to another view, changed his Y axis
    ///
    /// - Parameters:
    ///   - referenceView: view to equal the width and height
    ///   - yLayout: topAnchor or bottomAnchor to be referred
    ///   - space: distance between both views
    ///   - padding: optional padding spaces of referenceView
    func anchorEqualTo(view referenceView: UIView, atYLayout yLayout:NSLayoutYAxisAnchor, space:CGFloat, padding: UIEdgeInsets = .zero){
        anchor(top: nil, leading: referenceView.leadingAnchor, bottom: nil, trailing: referenceView.trailingAnchor, padding: padding)
        if yLayout == referenceView.topAnchor{
            bottomAnchor.constraint(equalTo: referenceView.topAnchor, constant: -space).isActive = true
        }
        if yLayout == referenceView.bottomAnchor{
            topAnchor.constraint(equalTo: referenceView.bottomAnchor, constant: space).isActive = true
        }
        heightAnchor.constraint(equalTo: referenceView.heightAnchor).isActive = true
    }
    
    /// Method to adjust width and height constraints equal to another view, changed his X axis
    ///
    /// - Parameters:
    ///   - referenceView: view to equal the width and height
    ///   - xLayout: leadingAnchor or trailingAnchor to be referred
    ///   - space: distance between both views
    ///   - padding: optional padding spaces of referenceView
    func anchorEqualTo(view referenceView: UIView, atXLayout xLayout:NSLayoutXAxisAnchor, space:CGFloat, padding: UIEdgeInsets = .zero){
        anchor(top: referenceView.topAnchor, leading: nil, bottom: referenceView.bottomAnchor, trailing: nil, padding: padding)
        if xLayout == referenceView.leadingAnchor{
            trailingAnchor.constraint(equalTo: referenceView.leadingAnchor, constant: space).isActive = true
        }
        if xLayout == referenceView.trailingAnchor{
            leadingAnchor.constraint(equalTo: referenceView.trailingAnchor, constant: -space).isActive = true
        }
        widthAnchor.constraint(equalTo: referenceView.widthAnchor).isActive = true
    }
}

