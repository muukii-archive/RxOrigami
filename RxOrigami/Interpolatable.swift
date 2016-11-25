// Interpolatable.swift
//
// Copyright (c) 2016 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public protocol Interpolatable {

  static func interpolate(progress: CGFloat, start: Self, end: Self) -> Self
}

extension CGFloat: Interpolatable {

  public static func interpolate(progress: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat {
    return ((end - start) * progress) + start
  }
}

extension UIColor: Interpolatable {

  public static func interpolate(progress: CGFloat, start: UIColor, end: UIColor) -> Self {

    let f = min(1, max(0, progress))

    guard let c1 = start.cgColor.components,
      let c2 = end.cgColor.components else {
        return self.init(white: 0, alpha: 0)
    }

    let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
    let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
    let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
    let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)

    return self.init(red:r, green:g, blue:b, alpha:a)
  }
}
