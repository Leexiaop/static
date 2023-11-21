### 什么是装饰器模式

    向一个现有的对象添加新的功能，同时又不改变其结构的设计模式被称为装饰器模式（Decorator Pattern），它是作为现有的类的一个包装（Wrapper）。

可以将装饰器理解为游戏人物购买的装备，例如LOL中的英雄刚开始游戏时只有基础的攻击力和法强。但是在购买的装备后，在触发攻击和技能时，能够享受到装备带来的输出加成。我们可以理解为购买的装备给英雄的攻击和技能的相关方法进行了装饰。

### ESnext中的装饰器模式

ESnext中有一个Decorator的提案，使用一个以 @ 开头的函数对ES6中的class及其属性、方法进行修饰。Decorator的详细语法请参考阮一峰的《ECMASciprt入门 —— Decorator》。

目前Decorator的语法还只是一个提案，如果期望现在使用装饰器模式，需要安装配合babel + webpack并结合插件实现。

+ npm安装依赖

```js
npm install babel-core babel-loader babel-plugin-transform-decorators babel-plugin-transform-decorators-legacy babel-preset-env
```

+ 配置.babelrc文件

```js
{
  "presets": ["env"],
  "plugins": ["transform-decorators-legacy"]
}
```

+ 在webpack.config.js中添加babel-loader

```js
  module: {
    rules: [
      { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" }
    ],
}
```
如果你使用的IDE为Visual Studio Code，可能还需要在项目根目录下添加以下tsconfig.json文件来组织一个ts检查的报错。

```js
{
  "compilerOptions": {
    "experimentalDecorators": true,
    "allowJs": true,
    "lib": [
      "es6"
    ],
  }
}
```
下面我将实现3个装饰器，分别为@autobind、@debounce、@deprecate。

### @autobind实现this`指向原对象

在JavaScript中，this的指向问题一直是一个老生常谈的话题，在Vue或React这类框架的使用过程中，新手很有可能一不小心就丢失了this的指向导致方法调用错误。例如下面一段代码：

```js
class Person {
  getPerson() {
    return this;
  }
}
​
let person = new Person();
let { getPerson } = person;
​
console.log(getPerson() === person); // false
```

上面的代码中， getPerson方法中的this默认指向Person类的实例，但是如果将Person通过解构赋值的方式提取出来，那么此时的this指向为undefined。所以最终的打印结果为false。

此时我们可以实现一个autobind的函数，用来装饰getPerson这个方法，实现this永远指向Person的实例。

```js
function autobind(target, key, descriptor) {
  var fn = descriptor.value;
  var configurable = descriptor.configurable;
  var enumerable = descriptor.enumerable;
​
  // 返回descriptor
  return {
    configurable: configurable,
    enumerable: enumerable,
    get: function get() {
      // 将该方法绑定this
      var boundFn = fn.bind(this);
      // 使用Object.defineProperty重新定义该方法
      Object.defineProperty(this, key, {
        configurable: true,
        writable: true,
        enumerable: false,
        value: boundFn
      })
​
      return boundFn;
    }
  }
}
```
我们通过bind实现了this的绑定，并在get中利用Object.defineProperty重写了该方法，将value定义为通过bind绑定后的函数boundFn，以此实现了this永远指向实例。下面我们为getPerson方法加上装饰并调用。

```js
class Person {
  @autobind
  getPerson() {
    return this;
  }
}
​
let person = new Person();
let { getPerson } = person;
​
console.log(getPerson() === person); // true

```

### @debounce`实现函数防抖

```js
  constructor() {
    this.content = '';
  }
​
  updateContent(content) {
    console.log(content);
    this.content = content;
    // 后面有一些消耗性能的操作
  }
}
​
const editor1 = new Editor();
editor1.updateContent(1);
setTimeout(() => { editor1.updateContent(2); }, 400);
​
​
const editor2= new Editor();
editor2.updateContent(3);
setTimeout(() => { editor2.updateContent(4); }, 600);
​
// 打印结果: 1 3 2 4
```
上面的代码中我们定义了Editor这个类，其中updateContent方法会在用户输入时执行并可能有一些消耗性能的DOM操作，这里我们在该方法内部打印了传入的参数以验证调用过程。可以看到4次的调用结果分别为1 3 2 4。

下面我们实现一个debounce函数，该方法传入一个数字类型的timeout参数。

```js
function debounce(timeout) {
  const instanceMap = new Map(); // 创建一个Map的数据结构，将实例化对象作为key
​
  return function (target, key, descriptor) {
​
    return Object.assign({}, descriptor, {
      value: function value() {
​
        // 清除延时器
        clearTimeout(instanceMap.get(this));
        // 设置延时器
        instanceMap.set(this, setTimeout(() => {
          // 调用该方法
          descriptor.value.apply(this, arguments);
          // 将延时器设置为 null
          instanceMap.set(this, null);
        }, timeout));
      }
    })
  }
}
```
上面的方法中，我们采用了ES6提供的Map数据结构去实现实例化对象和延时器的映射。在函数的内部，首先清除延时器，接着设置延时执行函数，这是实现debounce的通用方法，下面我们来测试一下debounce装饰器。

```js
class Editor {
  constructor() {
    this.content = '';
  }
​
  @debounce(500)  
  updateContent(content) {
    console.log(content);
    this.content = content;
  }
}
​
const editor1 = new Editor();
editor1.updateContent(1);
setTimeout(() => { editor1.updateContent(2); }, 400);
​
​
const editor2= new Editor();
editor2.updateContent(3);
setTimeout(() => { editor2.updateContent(4); }, 600);
​
//打印结果： 3 2 4
```
上面调用了4次updateContent方法，打印结果为3 2 4。1由于在400ms内被重复调用而没有被打印，这符合我们的参数为500的预期。

### @deprecate`实现警告提示

在使用第三方库的过程中，我们会时不时的在控制台遇见一些警告，这些警告用来提醒开发者所调用的方法会在下个版本中被弃用。这样的一行打印信息也许我们的常规做法是在方法内部添加一行代码即可，这样其实在源码阅读上并不友好，也不符合单一职责原则。如果在需要抛出警告的方法前面加一个@deprecate的装饰器来实现警告，会友好得多。

下面我们来实现一个@deprecate的装饰器，其实这类的装饰器也可以扩展成为打印日志装饰器@log，上报信息装饰器@fetchInfo等。

```js
function deprecate(deprecatedObj) {
​
  return function(target, key, descriptor) {
    const deprecatedInfo = deprecatedObj.info;
    const deprecatedUrl = deprecatedObj.url;
    // 警告信息
    const txt = `DEPRECATION ${target.constructor.name}#${key}: ${deprecatedInfo}. ${deprecatedUrl ? 'See '+ deprecatedUrl + ' for more detail' : ''}`;
    
    return Object.assign({}, descriptor, {
      value: function value() {
        // 打印警告信息
        console.warn(txt);
        descriptor.value.apply(this, arguments);
      }
    })
  }
}

```

上面的deprecate函数接受一个对象参数，该参数分别有info和url两个键值，其中info填入警告信息，url为选填的详情网页地址。下面我们来为一个名为MyLib的库的deprecatedMethod方法添加该装饰器吧！

```js
class MyLib {
  @deprecate({
    info: 'The methods will be deprecated in next version', 
    url: 'http://www.baidu.com'
  })
  deprecatedMethod(txt) {
    console.log(txt)
  }
}
​
const lib = new MyLib();
lib.deprecatedMethod('调用了一个要在下个版本被移除的方法');
// DEPRECATION MyLib#deprecatedMethod: The methods will be deprecated in next version. See http://www.baidu.com for more detail
// 调用了一个要在下个版本被移除的方法
```

### 总结

通过ESnext中的装饰器实现装饰器模式，不仅有为类扩充功能的作用，而且在阅读源码的过程中起到了提示作用。上面所举到的例子只是结合装饰器的新语法和装饰器模式做了一个简单封装，请勿用于生产环境。如果你现在已经体会到了装饰器模式的好处，并想在项目中大量使用，不妨看一下core-decorators这个库，其中封装了很多常用的装饰器。