//
//  RxOrigami.swift
//  RxOrigami
//
//  Created by muukii on 2016/11/22.
//  Copyright © 2016 muukii. All rights reserved.
//

import Foundation
import RxSwift

public enum Origami {

  public static func add(_ v1: Observable<CGFloat>, _ v2: Observable<CGFloat>) -> Observable<CGFloat> {
    return Observable.combineLatest(v1, v2) { $0 + $1 }
  }

  public static func substruct(_ v1: Observable<CGFloat>, _ v2: Observable<CGFloat>) -> Observable<CGFloat> {
    return Observable.combineLatest(v1, v2) { $0 - $1 }
  }

  public static func multiply(_ v1: Observable<CGFloat>, _ v2: Observable<CGFloat>) -> Observable<CGFloat> {
    return Observable.combineLatest(v1, v2) { $0 * $1 }
  }

  public static func point(x: Observable<CGFloat>, y: Observable<CGFloat>) -> Observable<CGPoint> {
    return Observable.combineLatest(x, y) { CGPoint(x: $0, y: $1) }
  }

  public static func size(width: Observable<CGFloat>, height: Observable<CGFloat>) -> Observable<CGSize> {
    return Observable.combineLatest(width, height) { CGSize(width: $0, height: $1) }
  }

  public static func clip(value: Observable<CGFloat>, min: Observable<CGFloat>, max: Observable<CGFloat>) -> Observable<CGFloat> {
    return Observable.combineLatest(value, min, max) { value, min, max in
      Swift.max(Swift.min(value, max),min)
    }
  }

  public static func translation(progress: Observable<CGFloat>, start: Observable<CGFloat>, end: Observable<CGFloat>) -> Observable<CGFloat> {
    return Observable.combineLatest(progress, start, end) { progress, start, end in
      ((end - start) * progress) + start
    }
  }

  public static func progress(value: Observable<CGFloat>, start: Observable<CGFloat>, end: Observable<CGFloat>) -> Observable<CGFloat> {
    return Observable.combineLatest(value, start, end) { value, start, end in
      (value - start) / (end - start)
    }
  }
}

extension ObservableType where E == CGFloat {

  public func add(_ v: Observable<CGFloat>) -> Observable<CGFloat> {

    return Origami.add(asObservable(), v)
  }

  public func substruct(_ v: Observable<CGFloat>) -> Observable<CGFloat> {
    return Origami.substruct(asObservable(), v)
  }

  public func multiply(_ v1: Observable<CGFloat>) -> Observable<CGFloat> {
    return Origami.multiply(asObservable(), v1)
  }

  public func point(y: Observable<CGFloat>) -> Observable<CGPoint> {
    return Origami.point(x: asObservable(), y: y)
  }

  public func point(x: Observable<CGFloat>) -> Observable<CGPoint> {
    return Origami.point(x: x, y: asObservable())
  }

  public func size(width: Observable<CGFloat>) -> Observable<CGSize> {
    return Origami.size(width: width, height: asObservable())
  }

  public func size(height: Observable<CGFloat>) -> Observable<CGSize> {
    return Origami.size(width: asObservable(), height: height)
  }

  public func clip(min: Observable<CGFloat>, max: Observable<CGFloat>) -> Observable<CGFloat> {
    return Origami.clip(value: asObservable(), min: min, max: max)
  }

  public func translation(start: Observable<CGFloat>, end: Observable<CGFloat>) -> Observable<CGFloat> {
    return Origami.translation(progress: asObservable(), start: start, end: end)
  }

  public func progress(start: Observable<CGFloat>, end: Observable<CGFloat>) -> Observable<CGFloat> {
    return Origami.progress(value: asObservable(), start: start, end: end)
  }
}
