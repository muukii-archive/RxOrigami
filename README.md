# RxOrigami

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Operator set for interactive animation. Inspired by [Origami Studio](http://origami.design/)

## Operators

### Add

![](./DocumentResources/add.png)

### Substruct

![](./DocumentResources/substruct.png)

### Multiply

![](./DocumentResources/muliply.png)

### Devide

![](./DocumentResources/devide.png)

### Progress

![](./DocumentResources/progress.png)

### Transition

![](./DocumentResources/transition.png)

### Max

![](./DocumentResources/max.png)

### Min

![](./DocumentResources/min.png)


## Example

![](./DocumentResources/example.png)

```swift
let label = UILabel()
let start = Variable<CGFloat>(10)
let end = Variable<CGFloat>(340)
let value = Variable<CGFloat>(18)

value.asObservable()
  .progress(
    start: start.asObservable(),
    end: end.asObservable()
  )
  .transition(start: 0, end: 1)
  .bindNext { alpha in
    label.alpha = alpha
}
```

# License

RxOrigami is available under the MIT license. See the LICENSE file for more info.
