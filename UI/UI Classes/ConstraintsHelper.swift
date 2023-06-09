//
//  ConstraintsHelper.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/28/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

struct ConstraintInfo {
	var attribute: NSLayoutConstraint.Attribute = .left
	var secondAttribute: NSLayoutConstraint.Attribute = .notAnAttribute
	var constant: CGFloat = 0
	var identifier: String?
	var relation: NSLayoutConstraint.Relation = .equal
}

precedencegroup ConstOp {
	associativity: left
	higherThan: AssignmentPrecedence
}

infix operator >>>-: ConstOp

@discardableResult
func >>>- <T: UIView>(left: (T, T), block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
	var info = ConstraintInfo()
	block(&info)
	info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute
	
	let constraint = NSLayoutConstraint(item: left.1,
										attribute: info.attribute,
										relatedBy: info.relation,
										toItem: left.0,
										attribute: info.secondAttribute,
										multiplier: 1,
										constant: info.constant)
	constraint.identifier = info.identifier
	left.0.addConstraint(constraint)
	return constraint
}

@discardableResult
func >>>- <T: UIView>(left: T, block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
	var info = ConstraintInfo()
	block(&info)
	
	let constraint = NSLayoutConstraint(item: left,
										attribute: info.attribute,
										relatedBy: info.relation,
										toItem: nil,
										attribute: info.attribute,
										multiplier: 1,
										constant: info.constant)
	constraint.identifier = info.identifier
	left.addConstraint(constraint)
	return constraint
}

@discardableResult
func >>>- <T: UIView>(left: (T, T, T), block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
	var info = ConstraintInfo()
	block(&info)
	info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute
	
	let constraint = NSLayoutConstraint(item: left.1,
										attribute: info.attribute,
										relatedBy: info.relation,
										toItem: left.2,
										attribute: info.secondAttribute,
										multiplier: 1,
										constant: info.constant)
	constraint.identifier = info.identifier
	left.0.addConstraint(constraint)
	return constraint
}

// MARK: UIView

extension UIView {
	
	func addScaleToFillConstratinsOnView(_ view: UIView) {
		[NSLayoutConstraint.Attribute.left, .right, .top, .bottom].forEach { attribute in
			(self, view) >>>- {
				$0.attribute = attribute
				return
			}
		}
	}
	
	func getConstraint(_ attributes: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		return constraints.first {
			if $0.firstAttribute == attributes && $0.secondItem == nil {
				return true
			} else {
				return false
			}
		}
	}
	
}
