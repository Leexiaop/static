## 概念
代理模式是为一个对象提供一个代用品或占位符，以便控制对它的访问。

## 场景
比如，明星都有经纪人作为代理。如果想请明星来办一场商业演出，只能联系他的经纪人。经纪人会把商业演出的细节和报酬都谈好之后，再把合同交给明星签。

## 分类


### 保护代理

于控制不同权限的对象对目标对象的访问，如上面明星经纪人的例子.

### 虚拟代理

把一些开销很大的对象，延迟到真正需要它的时候才去创建。
如短时间内发起很多个http请求，我们可以用虚拟代理实现一定时间内的请求统一发送

## 优缺点

### 优点

+ 1. 可以保护对象
+ 2. 优化性能，减少开销很大的对象
+ 3. 缓存结果

## 案例

### 加载一张图片

```js
  var myImage = (function () {
    var imgNode = document.createElement('img');
    document.body.appendChild(imgNode);
    return {
      setSrc: function (src) {
        imgNode.src = src;
      }
    }
  })();
  myImage.setSrc('https://xxxxxxx.com');
```
想象一下，如果我们的图片很大，用户就会看到页面很长一段时间是空白 我们可以想到的改进是图片加载完成之前都展示loading图片.

### 加个loading图片
```js
var myImage = (function () {
  var imgNode = document.createElement('img');
  document.body.appendChild(imgNode);
  var img = new Image()
  img.onload = () => {
    // 模拟图片加载
    setTimeout(() => {
      imgNode.src = img.src
    }, 1000)
  }
  return {
    setSrc: function (src) {
      img.src = src
      imgNode.src = 'https://content.igola.com/static/WEB/images/other/loading-searching.gif';
    }
  }
})();
myImage.setSrc('https://xxxxx.com');
```
这段代码违背了单一职责原则，这个对象同时承担了加载图片和预加载图片两个职责 同时也违背了开放封闭原则，如果我们以后不需要预加载图片了，那我们不得不修改整个对象.

### 用虚拟代理改进

```js
var myImage = (function () {
  var imgNode = document.createElement('img');
  document.body.appendChild(imgNode);
  return {
    setSrc: function (src) {
      imgNode.src = src
    }
  }
})();
​
var proxyImage = (function() {
  var img = new Image()
  img.onload = function() {
    myImage.setSrc(img.src)
  }
  return {
    setSrc: function (src) {
      img.src = src
      myImage.setSrc('https://content.igola.com/static/WEB/images/other/loading-searching.gif')
  }
  }
})()
​
​
proxyImage.setSrc('https://segmentfault.com/img/bVbmvnB?w=573&h=158');
```
注意：我们的代理和本体接口要保持一致性，如上面proxyImage和myImage都返回一个包含setSrc方法的对象。居于这点我们写代理的时候也有迹可循。

## 虚拟代理合并HTTP请求

### 简单的实现

```js
<body>
  <div id="wrapper">
    <input type="checkbox" id="1"></input>1
    <input type="checkbox" id="2"></input>2
    <input type="checkbox" id="3"></input>3
    <input type="checkbox" id="4"></input>4
    <input type="checkbox" id="5"></input>5
    <input type="checkbox" id="6"></input>6
    <input type="checkbox" id="7"></input>7
    <input type="checkbox" id="8"></input>8
    <input type="checkbox" id="9"></input>9
  </div>
</body>
​
<script type="text/javascript">
  // 模拟http请求
  var synchronousFile = function (id) {
    console.log('开始同步文件，id 为: ' + id);
  };
​
  var inputs = document.getElementsByTagName('input')
  var wrapper = document.getElementById('wrapper')
  wrapper.onclick = function (e) {
    if (e.target.tagName === 'INPUT') {
      synchronousFile(e.target.id)
    }
  }
</script>
```

缺点很明显：每点一次就发送一次http请求

### 改进

```js
<body>
  <div id="wrapper">
    <input type="checkbox" id="1"></input>1
    <input type="checkbox" id="2"></input>2
    <input type="checkbox" id="3"></input>3
    <input type="checkbox" id="4"></input>4
    <input type="checkbox" id="5"></input>5
    <input type="checkbox" id="6"></input>6
    <input type="checkbox" id="7"></input>7
    <input type="checkbox" id="8"></input>8
    <input type="checkbox" id="9"></input>9
  </div>
</body>
​
<script type="text/javascript">
  // 模拟http请求
  var synchronousFile = function (id) {
    console.log('开始同步文件，id 为: ' + id);
  };
​
  var inputs = document.getElementsByTagName('input')
  var wrapper = document.getElementById('wrapper')
  wrapper.onclick = function (e) {
    if (e.target.tagName === 'INPUT' && e.target.checked) {
      proxySynchronousFile(e.target.id)
    }
  }
​
  var proxySynchronousFile = (function () {
    var cacheIds = [],
      timeId = 0
    return function (id) {
      if (cacheIds.indexOf(id) < 0) {
        cacheIds.push(id)
      }
      clearTimeout(timeId)
      timeId = setTimeout(() => {
        synchronousFile(cacheIds.join(','))
        cacheIds = []
      }, 1000)
    }
  })()
</script>
```

## 缓存代理-计算乘积

### 粗糙的实现

```js
var mult = function () {
    console.log('开始计算乘积');
    var a = 1;
    for (var i = 0, l = arguments.length; i < l; i++) {
      a = a * arguments[i];
    }
    return a;
  };
  mult(2, 3); // 输出：6
  mult(2, 3, 4); // 输出：24
```
### 改进
```js
var mult = function () {
  console.log('开始计算乘积');
  var a = 1;
  for (var i = 0, l = arguments.length; i < l; i++) {
    a = a * arguments[i];
  }
  return a;
};
// mult(2, 3); // 输出：6
// mult(2, 3, 4); // 输出：24
​
var proxyMult = (function() {
  var cache = {}
  return function () {
    let id = Array.prototype.join.call(arguments, ',')
    if (cache[id]) {
      return cache[id]
    } else {
      return cache[id] = mult.apply(this, arguments)
    }
  }
})()
​
proxyMult(2, 3); // 输出：6
proxyMult(2, 3); // 输出：6
```
我们现在希望加法也能够缓存.

### 再改进

```js
var mult = function () {
  console.log('开始计算乘积');
  var a = 1;
  for (var i = 0, l = arguments.length; i < l; i++) {
    a = a * arguments[i];
  }
  return a;
};
​
var plus = function () {
  console.log('开始计算和');
  var a = 0;
  for (var i = 0, l = arguments.length; i < l; i++) {
    a = a + arguments[i];
  }
  return a;
};
​
​
// mult(2, 3); // 输出：6
// mult(2, 3, 4); // 输出：24
​
var createProxyFactory = function (fn) {
  var cache = {}
  return function () {
    let id = Array.prototype.join.call(arguments, ',')
    if (cache[id]) {
      return cache[id]
    } else {
      return cache[id] = fn.apply(this, arguments)
    }
  }
}
​
var proxyMult = createProxyFactory(mult),
  proxyPlus = createProxyFactory(plus);
proxyMult(1, 2, 3, 4) // 输出：24
proxyMult(1, 2, 3, 4) // 输出：24
proxyPlus(1, 2, 3, 4) // 输出：10
proxyPlus(1, 2, 3, 4) // 输出：10
```

## es6代理模式

### 基于类实现

```js
class Car {
    drive() {
        return "driving";
    };
}
​
class CarProxy {
    constructor(driver) {
        this.driver = driver;
    }
    drive() {
        return  ( this.driver.age < 18) ? "too young to drive" : new Car().drive();
    };
}
​
class Driver {
    constructor(age) {
        this.age = age;
    }
}
```
### 基于Proxy实现

```js

// 明星
let star = {
    name: '张XX',
    age: 25,
    phone: '13910733521'
}
​
// 经纪人
let agent = new Proxy(star, {
    get: function (target, key) {
        if (key === 'phone') {
            // 返回经纪人自己的手机号
            return '18611112222'
        }
        if (key === 'price') {
            // 明星不报价，经纪人报价
            return 120000
        }
        return target[key]
    },
    set: function (target, key, val) {
        if (key === 'customPrice') {
            if (val < 100000) {
                // 最低 10w
                throw new Error('价格太低')
            } else {
                target[key] = val
                return true
            }
        }
    }
})
​
// 主办方
console.log(agent.name)
console.log(agent.age)
console.log(agent.phone)
console.log(agent.price)
​
// 想自己提供报价（砍价，或者高价争抢）
agent.customPrice = 150000
// agent.customPrice = 90000  // 报错：价格太低
console.log('customPrice', agent.customPrice)

```
