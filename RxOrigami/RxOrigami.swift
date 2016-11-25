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

extension Observable {

  public static func add<V1: ObservableType, V2: ObservableType>(_ v1: V1, _ v2: V2) -> Observable<CGFloat> where V1.E == V2.E, V1.E : CGFloatConvertible {
    return Observable<CGFloat>.combineLatest(v1, v2) { $0.toCGFloat() + $1.toCGFloat() }
  }

  public static func substruct<V1: ObservableType, V2: ObservableType>(_ v1: V1, _ v2: V2) -> Observable<CGFloat> where V1.E == V2.E, V1.E : CGFloatConvertible {
    return Observable<CGFloat>.combineLatest(v1, v2) { $0.toCGFloat() - $1.toCGFloat() }
  }

  public static func multiply<V1: ObservableType, V2: ObservableType>(_ v1: V1, _ v2: V2) -> Observable<CGFloat> where V1.E == V2.E, V1.E : CGFloatConvertible {
    return Observable<CGFloat>.combineLatest(v1, v2) { $0.toCGFloat() * $1.toCGFloat() }
  }

  public static func point<T: CGFloatConvertible>(x: Observable<T>, y: Observable<T>) -> Observable<CGPoint> {
    return Observable<CGPoint>.combineLatest(x, y) { CGPoint(x: $0.toCGFloat(), y: $1.toCGFloat()) }
  }

  public static func size<T: CGFloatConvertible>(width: Observable<T>, height: Observable<T>) -> Observable<CGSize> {
    return Observable<CGSize>.combineLatest(width, height) { CGSize(width: $0.toCGFloat(), height: $1.toCGFloat()) }
  }

  public static func clip<T: CGFloatConvertible>(value: Observable<T>, min: Observable<T>, max: Observable<T>) -> Observable<CGFloat> {
    return Observable<CGFloat>.combineLatest(value, min, max) { value, min, max in
      Swift.max(Swift.min(value.toCGFloat(), max.toCGFloat()),min.toCGFloat())
    }
  }

  /**
   Convert a value between 0 and 1 (often a progress value) to a value between a new range defined by the start and end values.

   For example, if the start value is 50 and the end value is 100: - a progress of 0 will output 50 - a progress of .5 will output 75 - a progress of 1 will output 100

   The number wraps when progress exceeds the 0 to 1 range: - a progress of -.5 will output 25 - a progress of 2 will output 150
   */
  public static func transition<T: ObservableType, I: ObservableType>(progress: T, start: I, end: I) -> Observable<I.E> where I.E : Interpolatable, T.E : CGFloatConvertible {

    return Observable<I.E>.combineLatest(progress, start, end) { _progress, _start, _end in
      I.E.interpolate(progress: _progress.toCGFloat(), start: _start, end: _end)
    }
  }

  public static func progress<T: CGFloatConvertible>(value: Observable<T>, start: Observable<T>, end: Observable<T>) -> Observable<CGFloat> {
    return Observable<CGFloat>.combineLatest(value, start, end) { value, start, end in
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

    return Observable<CGFloat>.add(asObservable(), v)
  }

  public func substruct(_ v: Observable<E>) -> Observable<CGFloat> {
    return Observable<CGFloat>.substruct(asObservable(), v)
  }

  public func multiply(_ v1: Observable<E>) -> Observable<CGFloat> {
    return Observable<CGFloat>.multiply(asObservable(), v1)
  }

  public func point(y: Observable<E>) -> Observable<CGPoint> {
    return Observable<CGFloat>.point(x: asObservable(), y: y)
  }

  public func point(x: Observable<E>) -> Observable<CGPoint> {
    return Observable<CGPoint>.point(x: x, y: asObservable())
  }

  public func size(width: Observable<E>) -> Observable<CGSize> {
    return Observable<CGSize>.size(width: width, height: asObservable())
  }

  public func size(height: Observable<E>) -> Observable<CGSize> {
    return Observable<CGSize>.size(width: asObservable(), height: height)
  }

  public func clip(min: Observable<E>, max: Observable<E>) -> Observable<CGFloat> {
    return Observable<CGFloat>.clip(value: asObservable(), min: min, max: max)
  }

  public func clip(min: E, max: E) -> Observable<CGFloat> {
    return Observable<CGFloat>.clip(value: asObservable(), min: .just(min), max: .just(max))
  }

  public func transition<T: Interpolatable>(start: Observable<T>, end: Observable<T>) -> Observable<T> {
    return Observable<T>.transition(progress: asObservable(), start: start, end: end)
  }

  public func transition<I: Interpolatable>(start: I, end: I) -> Observable<I> {
    return Observable<I>.transition(progress: asObservable(), start: Observable<I>.just(start), end: Observable<I>.just(end))
  }

  public func transition<F: CGFloatConvertible>(start: F, end: F) -> Observable<CGFloat> {
    return Observable<F>.transition(progress: asObservable(), start: Observable<CGFloat>.just(start.toCGFloat()), end: Observable<CGFloat>.just(end.toCGFloat()))
  }

  public func progress(start: Observable<E>, end: Observable<E>) -> Observable<CGFloat> {
    return Observable<CGFloat>.progress(value: asObservable(), start: start, end: end)
  }

  public func progress(start: E, end: E) -> Observable<CGFloat> {
    return Observable<CGFloat>.progress(value: asObservable(), start: .just(start), end: .just(end))
  }

  public func reverseProgress() -> Observable<CGFloat> {
    return Observable<CGFloat>.reverseProgress(progress: asObservable())
  }

  public func absoluteValue() -> Observable<CGFloat> {
    return Observable<CGFloat>.absoluteValue(value: asObservable())
  }
}
