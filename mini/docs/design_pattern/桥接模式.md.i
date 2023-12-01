## 简介
桥接模式（Bridge）将抽象部分与它的实现部分分离，使它们都可以独立地变化。
其实就是函数的封装，比如要对某个DOM元素添加color和backgroundColor，可以封装个changeColor函数，这样可以在多个相似逻辑中提升智商...

## 实现

有时候在多维的变化中桥接模式更加实用，比如可以提取多个底层功能模块，比如提取运动，着色，说话模块，球类可以具有运动和着色模块，人类可以具有运动和说话模块，这样可以实现模块的快速组装，不仅仅是实现与抽象部分相分离了，而是更进一步功能与抽象相分离，进而 提升逼格 灵活的创建对象。

```js
class Speed {            // 运动模块
  constructor(x, y) {
    this.x = x
    this.y = y
  }
  run() {  console.log(`运动起来 ${this.x} + ${this.y}`)  }
}

class Color {            // 着色模块
  constructor(cl) {
    this.color = cl
  }
  draw() {  console.log(`绘制颜色 ${this.color}`)  }
}

class Speak {
  constructor(wd) {
    this.word = wd
  }
  say() {  console.log(`说话 ${this.word}`)  }
}

class Ball {                     // 创建球类，可以着色和运动
  constructor(x, y, cl) {
    this.speed = new Speed(x, y)
    this.color = new Color(cl)
  }
  init() {
    this.speed.run()
    this.color.draw()
  }
}

class Man {                    // 人类，可以运动和说话
  constructor(x, y, wd) {
    this.speed = new Speed(x, y)
    this.speak = new Speak(wd)
  }
  init() {
    this.speed.run()
    this.speak.say()
  }
}

const man = new Man(1, 2, 'hehe?')
man.init()    
```

### 总结
桥接模式的优点也很明显，我们只列举主要几个优点：

+ 分离接口和实现部分，一个实现未必不变地绑定在一个接口上，抽象类（函数）的实现可以在运行时刻进行配置，一个对象甚至可以在运行时刻改变它的实现，同将抽象和实现也进行了充分的解耦，也有利于分层，从而产生更好的结构化系统。
+ 提高可扩充性
+ 对客户隐藏实现细节。

同时桥接模式也有自己的缺点：
+ 大量的类将导致开发成本的增加，同时在性能方面可能也会有所减少。
