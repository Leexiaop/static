### 简介

工厂模式 （Factory Pattern），根据输入的不同返回不同类的实例，一般用来创建同一类对象。工厂方式的主要思想是将对象的创建与对象的实现分离。

抽象工厂模式(Abstract Factory)就是通过类的抽象使得业务适用于一个产品类簇的创建，而不负责某一类产品的实例。

JS中是没有直接的抽象类的，abstract是个保留字，但是还没有实现，因此我们需要在类的方法中抛出错误来模拟抽象类，如果继承的子类中没有覆写该方法而调用，就会抛出错误。

```js
const Car = function() { }
Car.prototype.getPrice = function() {return new Error('抽象方法不能调用')}
```

### 实现

面向对象的语言里有抽象工厂模式，首先声明一个抽象类作为父类，以概括某一类产品所需要的特征，继承该父类的子类需要实现父类中声明的方法而实现父类中所声明的功能：

#### 实例一

```js
/**
* 实现subType类对工厂类中的superType类型的抽象类的继承
* @param subType 要继承的类
* @param superType 工厂类中的抽象类type
*/
const VehicleFactory = function(subType, superType) {
  if (typeof VehicleFactory[superType] === 'function') {
    function F() {
      this.type = '车辆'
    } 
    F.prototype = new VehicleFactory[superType]()
    subType.constructor = subType
    subType.prototype = new F()                // 因为子类subType不仅需要继承superType对应的类的原型方法，还要继承其对象属性
  } else throw new Error('不存在该抽象类')
}
​
VehicleFactory.Car = function() {
  this.type = 'car'
}
VehicleFactory.Car.prototype = {
  getPrice: function() {
    return new Error('抽象方法不可使用')
  },
  getSpeed: function() {
    return new Error('抽象方法不可使用')
  }
}
​
const BMW = function(price, speed) {
  this.price = price
  this.speed = speed
}
VehicleFactory(BMW, 'Car')        // 继承Car抽象类
BMW.prototype.getPrice = function() {        // 覆写getPrice方法
  console.log(`BWM price is ${this.price}`)
}
BMW.prototype.getSpeed = function() {
  console.log(`BWM speed is ${this.speed}`)
}
​
const baomai5 = new BMW(30, 99)
baomai5.getPrice()                          // BWM price is 30
baomai5 instanceof VehicleFactory.Car       // true
```

#### 实例二

我们知道 JavaScript 并不强面向对象，也没有提供抽象类（至少目前没有提供），但是可以模拟抽象类。用对 new.target 来判断 new 的类，在父类方法中 throw new Error()，如果子类中没有实现这个方法就会抛错，这样来模拟抽象类：

```js
/* 抽象类，ES6 class 方式 */
class AbstractClass1 {
    constructor() {
        if (new.target === AbstractClass1) {
            throw new Error('抽象类不能直接实例化!')
        }
    }
​
    /* 抽象方法 */
    operate() { throw new Error('抽象方法不能调用!') }
}
​
/* 抽象类，ES5 构造函数方式 */
var AbstractClass2 = function () {
    if (new.target === AbstractClass2) {
        throw new Error('抽象类不能直接实例化!')
    }
}
/* 抽象方法，使用原型方式添加 */
AbstractClass2.prototype.operate = function(){ throw new Error('抽象方法不能调用!') }
```

下面用 JavaScript 将上面介绍的饭店例子实现一下。

首先使用原型方式：

```js
/* 饭店方法 */
function Restaurant() {}
​
Restaurant.orderDish = function(type) {
    switch (type) {
        case '鱼香肉丝':
            return new YuXiangRouSi()
        case '宫保鸡丁':
            return new GongBaoJiDing()
        case '紫菜蛋汤':
            return new ZiCaiDanTang()
        default:
            throw new Error('本店没有这个 -。-')
    }
}
​
/* 菜品抽象类 */
function Dish() { this.kind = '菜' }
​
/* 抽象方法 */
Dish.prototype.eat = function() { throw new Error('抽象方法不能调用!') }
​
/* 鱼香肉丝类 */
function YuXiangRouSi() { this.type = '鱼香肉丝' }
​
YuXiangRouSi.prototype = new Dish()
​
YuXiangRouSi.prototype.eat = function() {
    console.log(this.kind + ' - ' + this.type + ' 真香~')
}
​
/* 宫保鸡丁类 */
function GongBaoJiDing() { this.type = '宫保鸡丁' }
​
GongBaoJiDing.prototype = new Dish()
​
GongBaoJiDing.prototype.eat = function() {
    console.log(this.kind + ' - ' + this.type + ' 让我想起了外婆做的菜~')
}
​
const dish1 = Restaurant.orderDish('鱼香肉丝')
dish1.eat()
const dish2 = Restaurant.orderDish('红烧排骨')
​
// 输出: 菜 - 鱼香肉丝 真香~
// 输出: Error 本店没有这个 -。-
使用 class 语法改写一下：
​
/* 饭店方法 */
class Restaurant {
    static orderDish(type) {
        switch (type) {
            case '鱼香肉丝':
                return new YuXiangRouSi()
            case '宫保鸡丁':
                return new GongBaoJiDin()
            default:
                throw new Error('本店没有这个 -。-')
        }
    }
}
​
/* 菜品抽象类 */
class Dish {
    constructor() {
        if (new.target === Dish) {
            throw new Error('抽象类不能直接实例化!')
        }
        this.kind = '菜'
    }
    
    /* 抽象方法 */
    eat() { throw new Error('抽象方法不能调用!') }
}
​
/* 鱼香肉丝类 */
class YuXiangRouSi extends Dish {
    constructor() {
        super()
        this.type = '鱼香肉丝'
    }
    
    eat() { console.log(this.kind + ' - ' + this.type + ' 真香~') }
}
​
/* 宫保鸡丁类 */
class GongBaoJiDin extends Dish {
    constructor() {
        super()
        this.type = '宫保鸡丁'
    }
    
    eat() { console.log(this.kind + ' - ' + this.type + ' 让我想起了外婆做的菜~') }
}
​
const dish0 = new Dish()   // 输出: Error 抽象方法不能调用!
const dish1 = Restaurant.orderDish('鱼香肉丝')
dish1.eat()                                                                     // 输出: 菜 - 鱼香肉丝 真香~
const dish2 = Restaurant.orderDish('红烧排骨') // 输出: Error 本店没有这个 -。-
```

+ 这里的 Dish 类就是抽象产品类，继承该类的子类需要实现它的方法 eat。
+ 上面的实现将产品的功能结构抽象出来成为抽象产品类。事实上我们还可以更进一步，将工厂类也使用抽象类约束一下，也就是抽象工厂类，比如这个饭店可以做菜和汤，另一个饭店也可以做菜和汤，存在共同的功能结构，就可以将共同结构作为抽象类抽象出来，实现如下：

```js
/* 饭店 抽象类，饭店都可以做菜和汤 */
class AbstractRestaurant {
    constructor() {
        if (new.target === AbstractRestaurant)
            throw new Error('抽象类不能直接实例化!')
        this.signborad = '饭店'
    }
    
    /* 抽象方法：创建菜 */
    createDish() { throw new Error('抽象方法不能调用!') }
    
    /* 抽象方法：创建汤 */
    createSoup() { throw new Error('抽象方法不能调用!') }
}
​
/* 具体饭店类 */
class Restaurant extends AbstractRestaurant {
    constructor() { super() }
    
    createDish(type) {
        switch (type) {
            case '鱼香肉丝':
                return new YuXiangRouSi()
            case '宫保鸡丁':
                return new GongBaoJiDing()
            default:
                throw new Error('本店没这个菜')
        }
    }
    
    createSoup(type) {
        switch (type) {
            case '紫菜蛋汤':
                return new ZiCaiDanTang()
            default:
                throw new Error('本店没这个汤')
        }
    }
}
​
/* 菜 抽象类，菜都有吃的功能 eat */
class AbstractDish {
    constructor() {
        if (new.target === AbstractDish) {
            throw new Error('抽象类不能直接实例化!')
        }
        this.kind = '菜'
    }
    
    /* 抽象方法 */
    eat() { throw new Error('抽象方法不能调用!') }
}
​
/* 菜 鱼香肉丝类 */
class YuXiangRouSi extends AbstractDish {
    constructor() {
        super()
        this.type = '鱼香肉丝'
    }
    
    eat() { console.log(this.kind + ' - ' + this.type + ' 真香~') }
}
​
/* 菜 宫保鸡丁类 */
class GongBaoJiDing extends AbstractDish {
    constructor() {
        super()
        this.type = '宫保鸡丁'
    }
    
    eat() { console.log(this.kind + ' - ' + this.type + ' 让我想起了外婆做的菜~') }
}
​
/* 汤 抽象类，汤都有喝的功能 drink */
class AbstractSoup {
    constructor() {
        if (new.target === AbstractDish) {
            throw new Error('抽象类不能直接实例化!')
        }
        this.kind = '汤'
    }
    
    /* 抽象方法 */
    drink() { throw new Error('抽象方法不能调用!') }
}
​
/* 汤 紫菜蛋汤类 */
class ZiCaiDanTang extends AbstractSoup {
    constructor() {
        super()
        this.type = '紫菜蛋汤'
    }
    
    drink() { console.log(this.kind + ' - ' + this.type + ' 我从小喝到大~') }
}
​
​
const restaurant = new Restaurant()
​
const soup1 = restaurant.createSoup('紫菜蛋汤')
soup1.drink()                                                                       // 输出: 汤 - 紫菜蛋汤 我从小喝到大~
const dish1 = restaurant.createDish('鱼香肉丝')
dish1.eat()                                                                         // 输出: 菜 - 鱼香肉丝 真香~
const dish2 = restaurant.createDish('红烧排骨')  // 输出: Error 本店没有这个 -。-
```
这样如果创建新的饭店，新的饭店继承这个抽象饭店类，那么也要实现抽象饭店类，这样就都具有抽象饭店类制定的结构。

### 抽象工厂模式的通用实现

    我们提炼一下抽象工厂模式，饭店还是工厂（Factory），菜品种类是抽象类（AbstractFactory），而实现抽象类的菜品是具体的产品（Product），通过工厂拿到实现了不同抽象类的产品，这些产品可以根据实现的抽象类被区分为类簇。主要有下面几个概念：

+ Factory ：工厂，负责返回产品实例；
+ AbstractFactory ：虚拟工厂，制定工厂实例的结构；
+ Product ：产品，访问者从工厂中拿到的产品实例，实现抽象类；
+ AbstractProduct ：产品抽象类，由具体产品实现，制定产品实例的结构；

下面是通用的实现，原型方式略过：
```js
/* 工厂 抽象类 */
class AbstractFactory {
    constructor() {
        if (new.target === AbstractFactory) 
            throw new Error('抽象类不能直接实例化!')
    }
    
    /* 抽象方法 */
    createProduct1() { throw new Error('抽象方法不能调用!') }
}
​
/* 具体饭店类 */
class Factory extends AbstractFactory {
    constructor() { super() }
    
    createProduct1(type) {
        switch (type) {
            case 'Product1':
                return new Product1()
            case 'Product2':
                return new Product2()
            default:
                throw new Error('当前没有这个产品 -。-')
        }
    }
}
​
/* 抽象产品类 */
class AbstractProduct {
    constructor() {
        if (new.target === AbstractProduct) 
            throw new Error('抽象类不能直接实例化!')
        this.kind = '抽象产品类1'
    }
    
    /* 抽象方法 */
    operate() { throw new Error('抽象方法不能调用!') }
}
​
/* 具体产品类1 */
class Product1 extends AbstractProduct {
    constructor() {
        super()
        this.type = 'Product1'
    }
    
    operate() { console.log(this.kind + ' - ' + this.type) }
}
​
/* 具体产品类2 */
class Product2 extends AbstractProduct {
    constructor() {
        super()
        this.type = 'Product2'
    }
    
    operate() { console.log(this.kind + ' - ' + this.type) }
}
​
​
const factory = new Factory()
​
const prod1 = factory.createProduct1('Product1')
prod1.operate()                                                                     // 输出: 抽象产品类1 - Product1
const prod2 = factory.createProduct1('Product3')    // 输出: Error 当前没有这个产品 -。-
```
+ 如果希望增加第二个类簇的产品，除了需要改一下对应工厂类之外，还需要增加一个抽象产品类，并在抽象产品类基础上扩展新的产品。
+ 我们在实际使用的时候不一定需要每个工厂都继承抽象工厂类，比如只有一个工厂的话我们可以直接使用工厂模式，在实战中灵活使用。

### 抽象工厂模式的优缺点

+ 抽象模式的优点：

    抽象产品类将产品的结构抽象出来，访问者不需要知道产品的具体实现，只需要面向产品的结构编程即可，从产品的具体实现中解耦；

+ 抽象模式的缺点：

    + 扩展新类簇的产品类比较困难，因为需要创建新的抽象产品类，并且还要修改工厂类，违反开闭原则；
    
    + 带来了系统复杂度，增加了新的类，和新的继承关系；

### 总结

抽象类创建出的结果不是一个真实的对象实例，而是一个类簇，它指定了类的结构，这也就区别于简单工厂模式创建单一对象，工厂模式创建多类对象。

通过抽象工厂，就可以创建某个类簇的产品，并且也可以通过instanceof来检查产品的类别，也具备该类簇所必备的方法。
