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

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let pan = UIPanGestureRecognizer()
    let x = pan.rx.event.map { gesture in

      gesture.translation(in: self.view).y
    }

    Origami.add(x, .just(1000))
      .debug()
      .subscribe()

    view.addGestureRecognizer(pan)
  }
  @IBOutlet weak var box: UIView!
}

