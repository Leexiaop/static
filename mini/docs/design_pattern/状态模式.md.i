## 简介
状态模式(State)允许一个对象在其内部状态改变的时候改变它的行为，对象看起来似乎修改了它的类。
其实就是用一个对象或者数组记录一组状态，每个状态对应一个实现，实现的时候根据状态挨个去运行实现。

## 实现
比如超级玛丽，就可能同时有好几个状态比如 跳跃，移动，射击，蹲下 等，如果对这些动作一个个进行处理判断，需要多个if-else或者switch不仅丑陋不说，而且在遇到有组合动作的时候，实现就会变的更为复杂，这里可以使用状态模式来实现。

状态模式的思路是：首先创建一个状态对象或者数组，内部保存状态变量，然后内部封装好每种动作对应的状态，然后状态对象返回一个接口对象，它可以对内部的状态修改或者调用。

```js
const SuperMarry = (function() {    
  let _currentState = [],        // 状态数组
      states = {
        jump() {console.log('跳跃!')},
        move() {console.log('移动!')},
        shoot() {console.log('射击!')},
        squat() {console.log('蹲下!')}
      }
  
  const Action = {
    changeState(arr) {  // 更改当前动作
      _currentState = arr
      return this
    },
    goes() {
      console.log('触发动作')
      _currentState.forEach(T => states[T] && states[T]())
      return this
    }
  }
  
  return {
    change: Action.changeState,
    go: Action.goes
  }
})()

SuperMarry
    .change(['jump', 'shoot'])
    .go()                    // 触发动作  跳跃!  射击!
    .go()                    // 触发动作  跳跃!  射击!
    .change(['squat'])
    .go()                    // 触发动作  蹲下!
```
这里可以使用ES6的class优化一下： 
```js
class SuperMarry {
  constructor() {
    this._currentState = []
    this.states = {
      jump() {console.log('跳跃!')},
      move() {console.log('移动!')},
      shoot() {console.log('射击!')},
      squat() {console.log('蹲下!')}
    }
  }
  
  change(arr) {  // 更改当前动作
    this._currentState = arr
    return this
  }
  
  go() {
    console.log('触发动作')
    this._currentState.forEach(T => this.states[T] && this.states[T]())
    return this
  }
}

new SuperMarry()
    .change(['jump', 'shoot'])
    .go()                    // 触发动作  跳跃!  射击!
    .go()                    // 触发动作  跳跃!  射击!
    .change(['squat'])
    .go()                    // 触发动作  蹲下!
```

## 总结
状态模式的使用场景也特别明确，有如下两点：

1. 一个对象的行为取决于它的状态，并且它必须在运行时刻根据状态改变它的行为。
2. 一个操作中含有大量的分支语句，而且这些分支语句依赖于该对象的状态。状态通常为一个或多个枚举常量的表示。