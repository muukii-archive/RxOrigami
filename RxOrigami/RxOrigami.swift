// RxOrigami.swift
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
import RxSwift

public enum Curve {
  case WIP
}

public enum Origami {

  public static func add<T: CGFloatConvertible>(_ v1: Observable<T>, _ v2: Observable<T>) -> Observable<CGFloat> {
    return Observable.combineLatest(v1, v2) { $0.toCGFloat() + $1.toCGFloat() }
  }

  public static func substruct<T: CGFloatConvertible>(_ v1: Observable<T>, _ v2: Observable<T>) -> Observable<CGFloat> {
    return Observable.combineLatest(v1, v2) { $0.toCGFloat() - $1.toCGFloat() }
  }

  public static func multiply<T: CGFloatConvertible>(_ v1: Observable<T>, _ v2: Observable<T>) -> Observable<CGFloat> {
    return Observable.combineLatest(v1, v2) { $0.toCGFloat() * $1.toCGFloat() }
  }

  public static func point<T: CGFloatConvertible>(x: Observable<T>, y: Observable<T>) -> Observable<CGPoint> {
    return Observable.combineLatest(x, y) { CGPoint(x: $0.toCGFloat(), y: $1.toCGFloat()) }
  }

  public static func size<T: CGFloatConvertible>(width: Observable<T>, height: Observable<T>) -> Observable<CGSize> {
    return Observable.combineLatest(width, height) { CGSize(width: $0.toCGFloat(), height: $1.toCGFloat()) }
  }

  public static func clip<T: CGFloatConvertible>(value: Observable<T>, min: Observable<T>, max: Observable<T>) -> Observable<CGFloat> {
    return Observable.combineLatest(value, min, max) { value, min, max in
      Swift.max(Swift.min(value.toCGFloat(), max.toCGFloat()),min.toCGFloat())
    }
  }

  /**
   Convert a value between 0 and 1 (often a progress value) to a value between a new range defined by the start and end values.

   For example, if the start value is 50 and the end value is 100: - a progress of 0 will output 50 - a progress of .5 will output 75 - a progress of 1 will output 100

   The number wraps when progress exceeds the 0 to 1 range: - a progress of -.5 will output 25 - a progress of 2 will output 150
   */
  public static func transition<T: CGFloatConvertible, I: Interpolatable>(progress: Observable<T>, start: Observable<I>, end: Observable<I>) -> Observable<I> {
    return Observable.combineLatest(progress, start, end) { progress, start, end in
      I.interpolate(progress: progress.toCGFloat(), start: start, end: end)
    }
  }

  public static func progress<T: CGFloatConvertible>(value: Observable<T>, start: Observable<T>, end: Observable<T>) -> Observable<CGFloat> {
    return Observable.combineLatest(value, start, end) { value, start, end in
      (value.toCGFloat() - start.toCGFloat()) / (end.toCGFloat() - start.toCGFloat())
    }
  }

  /**
   Reverse a progress value, ex: 0 to 1 becomes 1 to 0, .3 becomes .7.

   Useful to sync an animation that is reversed (ex: a photo that fades in as another fades out).
   */
  public static func reverseProgress<T: CGFloatConvertible>(progress: Observable<T>) -> Observable<CGFloat> {
    return progress.map { 1 - $0.toCGFloat() }
  }

  public static func absoluteValue<T: CGFloatConvertible>(value: Observable<T>) -> Observable<CGFloat> {
    return value.map { abs($0.toCGFloat()) }
  }

  public static func curve<T: CGFloatConvertible>(progress: Observable<T>, curve: Curve) -> Observable<CGFloat> {
    fatalError("TODO")
  }
}

extension ObservableType where E : CGFloatConvertible {

  public func add(_ v: Observable<E>) -> Observable<CGFloat> {

    return Origami.add(asObservable(), v)
  }

  public func substruct(_ v: Observable<E>) -> Observable<CGFloat> {
    return Origami.substruct(asObservable(), v)
  }

  public func multiply(_ v1: Observable<E>) -> Observable<CGFloat> {
    return Origami.multiply(asObservable(), v1)
  }

  public func point(y: Observable<E>) -> Observable<CGPoint> {
    return Origami.point(x: asObservable(), y: y)
  }

  public func point(x: Observable<E>) -> Observable<CGPoint> {
    return Origami.point(x: x, y: asObservable())
  }

  public func size(width: Observable<E>) -> Observable<CGSize> {
    return Origami.size(width: width, height: asObservable())
  }

  public func size(height: Observable<E>) -> Observable<CGSize> {
    return Origami.size(width: asObservable(), height: height)
  }

  public func clip(min: Observable<E>, max: Observable<E>) -> Observable<CGFloat> {
    return Origami.clip(value: asObservable(), min: min, max: max)
  }

  public func transition<T: Interpolatable>(start: Observable<T>, end: Observable<T>) -> Observable<T> {
    return Origami.transition(progress: asObservable(), start: start, end: end)
  }

  public func progress(start: Observable<E>, end: Observable<E>) -> Observable<CGFloat> {
    return Origami.progress(value: asObservable(), start: start, end: end)
  }

  public func reverseProgress() -> Observable<CGFloat> {
    return Origami.reverseProgress(progress: asObservable())
  }

  public func absoluteValue() -> Observable<CGFloat> {
    return Origami.absoluteValue(value: asObservable())
  }
}
