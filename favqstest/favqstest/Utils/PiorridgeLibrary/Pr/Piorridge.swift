//
//  Piorridge.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 15/05/2020.
//

import Foundation
import UIKit

/// - Wrapper for Piorridge methods as an extension
public class Piorridge<Ext> {
	public var own: Ext

	init(own: Ext) {
		self.own = own
	}
}
/// - Compatibility with an object to use Piorridge
public protocol PiorridgeObj: AnyObject { }
extension PiorridgeObj {
	public var pr: Piorridge<Self> { return Piorridge(own: self) }
}

/// - Compatibility with a value to use Piorridge
public protocol PiorridgeVal {}
extension PiorridgeVal {
	public var pr: Piorridge<Self> { return Piorridge(own: self) }
}

/// -
public class Pr: NSObject {

}
