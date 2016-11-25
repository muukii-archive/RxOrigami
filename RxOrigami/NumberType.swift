//
//  NumberType.swift
//  RxOrigami
//
//  Created by muukii on 2016/11/25.
//  Copyright © 2016 muukii. All rights reserved.
//

import Foundation

public protocol CGFloatConvertible {
  func toCGFloat() -> CGFloat
}

extension CGFloat: CGFloatConvertible {
  public func toCGFloat() -> CGFloat {
    return self
  }
}

extension Float: CGFloatConvertible {
  public func toCGFloat() -> CGFloat {
    return CGFloat(self)
  }
}

extension Double: CGFloatConvertible {
  public func toCGFloat() -> CGFloat {
    return CGFloat(self)
  }
}
