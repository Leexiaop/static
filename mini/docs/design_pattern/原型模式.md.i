## 什么是原型模式

原型模式(Prototype pattern)，用原型实例指向创建对象的类，使用于创建新的对象的类的共享原型的属性与方法。

## 实现

1. 每一个函数数据类型(普通函数、类)都有一个天生自带的属性:prototype(原型),并且这个属性是一个对象数据类型的值。
2. 并且在prototype上浏览器天生给它加了一个属性constructor(构造函数),属性值是当前函数(类)本身。
3. 每一个对象数据类型(普通的对象、实例)也天生自带一个属性'proto',属性值是当前实例所属类的原型(prototype)。

```js
function Fn() {
    this.x = 100;
    this.sum = function() {
​
    }
};
​
Fn.prototype.getX = function() {
    console.log(this.x);
};
//再在公有链上增加一个sum
Fn.prototype.sum = function() {
​
}
​
var f1 = new Fn;
var f2 = new Fn;
console.log(Fn.prototype.constructor === Fn);
```
对于原型模式，我们可以利用JavaScript特有的原型继承特性去创建对象的方式，也就是创建的一个对象作为另外一个对象的prototype属性值。原型对象本身就是有效地利用了每个构造器创建的对象，例如，如果一个构造函数的原型包含了一个name属性（见后面的例子），那通过这个构造函数创建的对象都会有这个属性。

```js
// 因为不是构造函数，所以不用大写
var someCar = {
    drive: function () { },
    name: '马自达 3'
};
​
// 使用Object.create创建一个新车x
var anotherCar = Object.create(someCar);
anotherCar.name = '马大哈';
```

Object.create运行你直接从其它对象继承过来，使用该方法的第二个参数，你可以初始化额外的其它属性。例如：

```js
var vehicle = {
    getModel: function () {
        console.log('车辆的模具是：' + this.model);
    }
};
​
var car = Object.create(vehicle, {
    'id': {
        value: MY_GLOBAL.nextId(),
        enumerable: true // 默认writable:false, configurable:false
    },
    'model': {
        value: '福特',
        enumerable: true
    }
});
```

这里，可以在Object.create的第二个参数里使用对象字面量传入要初始化的额外属性，其语法与Object.defineProperties或Object.defineProperty方法类似。它允许您设定属性的特性，例如enumerable, writable 或 configurable。

如果你希望自己去实现原型模式，而不直接使用Object.create 。你可以使用像下面这样的代码为上面的例子来实现：

```js
var vehiclePrototype = {
    init: function (carModel) {
        this.model = carModel;
    },
    getModel: function () {
        console.log('车辆模具是：' + this.model);
    }
};
​
function vehicle(model) {
    function F() { };
    F.prototype = vehiclePrototype;
​
    var f = new F();
​
    f.init(model);
    return f;
}
​
var car = vehicle('福特Escort');
car.getModel();
```

## 总结

原型模式在JavaScript里的使用简直是无处不在，其它很多模式有很多也是基于prototype的，这里大家要注意的依然是浅拷贝和深拷贝的问题，免得出现引用问题。

原型模式适合在创建复杂对象时，对于那些需求一直在变化而导致对象结构不停地改变时，将那些比较稳定的属性与方法共用而提取的继承的实现。

