## 外观模式

外观模式是指提供一个统一的接口去访问多个子系统的多个不同的接口，为子系统中的一组接口提供统一的高层接口。使得子系统更容易使用，不仅简化类中的接口，而且实现调用者和接口的解耦。
外观模式在我们的日常工作中十分常见。

我们来看一个例子：
```js
// a.js
export default {
    getA (params) {
        // do something...
    }
}

// b.js 
export default {
    getB (params) {
        // do something...
    }
}

// app.js  外观模式为子系统提供同一的高层接口
import A from './a'
import B from './b'
export default {
    A,
    B
}

// 通过同一接口调用子系统

import app from './app'

app.A.getA(params);
app.B.getB(params);
```

## 与适配器模式的区别

适配器模式是将一个对象包装起来以改变其接口，而外观模式是将一群对象包装起来以简化其接口。
适配器是将接口转换为不同接口，而外观模式是提供一个统一的接口来简化接口。

## 外观设计模式

外部与一个子系统的通信必须通过一个统一的门面(Facade)对象进行，这就是门面模式。
外观模式为子系统提供了统一的界面, 屏蔽了子类的不同
现代大型软件发展到一定程度会非常复杂, 于是就需要对软件进行模块化开发, 将系统分成各个模块, 有利于维护和拓展,但即使这样在我们调用的时候依然要和许多类打交道, 依然很复杂, 于是外观设计模式应运而生. 外观设计模式就是为多个子系统提供一个统一的外观类来简化外部人员操作, 下面是使用外观模式前后的的医院案例.

外观模式就好像一个接待员免去了外部人员与各个科室进行交流, 应为各个科室运作流程还是比较复杂的, 通过一个熟悉业务的外观类可以大大提高医院的效率.

### 外观模式设计两种对象

+ 外观类: 客户端调用这个角色的方法。此角色知晓相关的子系统的功能和责任。正常情况下，本角色会将所有从客户端发来的请求委派到相应的子系统中去.
+ 子系统类:可以同时有一个或者多个子系统。每个子系统都不是一个单独的类，而是一个类的集合。每一个子系统都可以被客户端直接调用，或者被门面角色直接调用。子系统并不知道门面的存在，对于子系统而言，门面仅仅是另一个客户端而已。

## 实现
+ 未使用外观模式

```js
let Light = function () {  
};
Light.prototype.turnOn = function () {
 console.log('Light turn on');
};
Light.prototype.turnOff = function () {
 console.log('Light turn off');
};
​
let TV = function () { 
};
TV.prototype.turnOn = function () {
 console.log('TV turn on');
};
TV.prototype.turnOff = function () {
 console.log('TV turn off');
};
​
let Computer = function () {
};
Computer.prototype.turnOn = function () {
 console.log('Computer turn on');
};
Computer.prototype.turnOff = function () {
 console.log('Computer turn off');
};
```
+ 客户端调用
```js
let light = new Light();
let tv = new TV();
let computer = new Computer();
​
light.turnOn();
tv.turnOn();
computer.turnOn();
​
light.turnOff();
tv.turnOff();
computer.turnOff();
```
+ 使用外观模式
```js
let Facade = function () {
 this.light = new Light();
 this.tv = new TV();
 this.computer = new Computer();
}
Facade.prototype.turnOn = function () {
 light.turnOn();
 tv.turnOn();
 computer.turnOn();
}
Facade.prototype.turnOff = function () {
 light.turnOff();
 tv.turnOff();
 computer.turnOff();
}
```
+ 客户端调用
```js
let facade = new Facade();
​
facade.turnOn();
facade.turnOff();
```