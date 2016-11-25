//
//  ViewController.swift
//  Example
//
//  Created by muukii on 2016/11/22.
//  Copyright © 2016 muukii. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxOrigami

final class ViewController: UIViewController {

  // MARK: - Properties

  @IBOutlet weak var scaleBox: UIView!
  @IBOutlet weak var box: UIView!
  @IBOutlet weak var maxColorBox: UIView!
  @IBOutlet weak var minColorBox: UIView!
  @IBOutlet weak var progressSlider: UISlider!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var valueSlider: UISlider!
  @IBOutlet weak var minLabel: UILabel!
  @IBOutlet weak var maxLabel: UILabel!
  let disposeBag = DisposeBag()

  // MARK: - Functions

  override func viewDidLoad() {
    super.viewDidLoad()

    let animation = CABasicAnimation(keyPath: "transform")
    animation.fromValue = CATransform3DMakeScale(0.5, 1, 1)
    animation.toValue = CATransform3DMakeScale(1.9, 0.4, 1)
    animation.duration = 1
    scaleBox.layer.add(animation, forKey: nil)

//    self.scaleBox.transform = CGAffineTransform(scaleX: 0.5, y: 1)
//    UIView.animate(withDuration: 1, animations: {
//      self.scaleBox.transform = CGAffineTransform(scaleX: 1.9, y: 0.4)
//    })
    scaleBox.layer.speed = 0

    let startColor = UIColor(red:0.24, green:0.42, blue:0.58, alpha:1.00)
    let endColor = UIColor(red:0.93, green:0.72, blue:0.16, alpha:1.00)

    minColorBox.backgroundColor = startColor
    maxColorBox.backgroundColor = endColor

    minLabel.text = String(valueSlider.minimumValue)
    maxLabel.text = String(valueSlider.maximumValue)

    let progress = valueSlider.rx.value
      .progress(
        start: Observable.just(valueSlider.minimumValue),
        end: Observable.just(valueSlider.maximumValue)
      )
      .do(onNext: { progress in

        // Debug presentation
        self.progressSlider.value = Float(progress)
        self.progressLabel.text = String(Float(progress))
      })
      .shareReplay(1)

    progress
      .transition(
        start: Observable<UIColor>.just(startColor),
        end: Observable<UIColor>.just(endColor)
      )
      .bindNext { color in
        self.box.backgroundColor = color
      }
      .addDisposableTo(disposeBag)

    progress
      .asTimeOffset()
      .bindNext { time in
      self.scaleBox.layer.timeOffset = time
    }

    progress
      .progress(
        start: Observable<CGFloat>.just(0),
        end: Observable<CGFloat>.just(0.3)
      )
      .transition(
        start: Observable<CGFloat>.just(0),
        end: Observable<CGFloat>.just(1)
      )
      .bindNext { alpha in

    }

    progress.transition(
      start: Observable<CGFloat>.just(0.1),
      end: Observable<CGFloat>.just(1.3)
      )
      .debug()
      .bindNext { scale in
//        self.scaleBox.transform = CGAffineTransform(scaleX: scale, y: scale)

      }
      .addDisposableTo(disposeBag)
  }
}

