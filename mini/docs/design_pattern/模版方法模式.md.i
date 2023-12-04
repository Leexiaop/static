## JavaScript-模板方法模式
模板方法是什么鬼？模板模式又是什么鬼？? 听说它很复杂，听说它很难，我可不可以不学啊?。刷了一会儿微博，这几天杨洋的新电影《三生三世十里桃花》上映了，不行，我要去看，虽然闺蜜说不好看，但是，去看杨洋也是可以的，嘻嘻嘻。 嗯，模板模式应该是跟杨洋一样帅，所以带着这份爱慕，我们一起来看看它到底有没有比杨洋还要帅！！

## 模板方法模式是什么？
模板方法模式是一种只需使用继承就可以实现的非常简单的模式。这是它的一种定义，简单吗？不觉得。?

说到继承，我们一定会能够想到它肯定有父亲，不然要怎么继承。模板方法模式由两部分结构组成，第一部分是抽象父类，第二部分是具体实现的子类。完了，又出来一个概念，抽象类？别怕，我们一一来讲解。在模板方法模式中，子类实现中的相同部分被上移到父类中，而将不同的部分留给子类来实现。
## 一杯咖啡
首先我们先来泡一杯咖啡，一般来说，泡咖啡的步骤通常如下：

1.先把水煮沸；

2.用沸水冲泡咖啡；

3.把咖啡倒进杯子；

4.加糖和牛奶。

我们用es5来得到一杯香浓的咖啡吧：
```js
var Coffee=function(){}
Coffee.prototype.boilWater=function(){
    console.log('水煮开了');
}
Coffee.prototype.brewCoffeeGriends=function(){
    console.log('用沸水冲泡咖啡');
}
Coffee.prototype.pourInCup=function(){
    console.log('把咖啡倒进杯子');
}
Coffee.prototype.addSugarAndMilk=function(){
    console.log('加糖和牛奶');
}
// 封装 将实现的细节交给类的内部
Coffee.prototype.init = function() {
            this.boilWater();
            this.brewCoffeeGriends();
            this.pourInCup();
            this.addSugarAndMilk();
}
var coffee=new Coffee();
coffee.init();
```

如我们所愿了，控制台会输出泡茶的流程，和我们写下的一样。

我想喝茶吖，想喝茶。不急，不急，我们再来泡茶哈！
## 泡一壶茶啦

其实呢，泡茶的步骤跟泡咖啡的步骤相差不大，大致是这样的：

1.把水煮沸；

2.用沸水浸泡茶叶；

3.把茶水倒进杯子；

4.加柠檬。

来，咱用es6来泡茶：

```js
class Tea{
    constructor(){

    }
    boilWater(){
        console.log('把水烧开');
    }
    steepTeaBag(){
        console.log('浸泡茶叶');
    }
    pourInCup(){
        console.log('倒进杯子');
    }
    addLemon(){
        console.log('加柠檬');
    }
    init(){
            this.boilWater();
            this.steepTeaBag();
            this.pourInCup();
            this.addLemon();
    }
}
var tea=new Tea();
tea.init();
```
又如我们所愿了，控制台输出了泡茶的流程。

## 思考
现在到了思考的时间，我们刚刚泡了一杯咖啡和一壶茶，有没有觉得这两个过程是大同小异的。我们能很容易的就找出他们的共同点，不同点就是原料不同嘛，茶和咖啡，我们可以把他们抽象为"饮料"哇；泡的方式不同嘛，一个是冲泡，一个是浸泡，我们可以把这个行为抽象为"泡"；加入的调料也不同咯，加糖和牛奶，加柠檬，它们也可以抽象为"调料"吖。

这么一分析，是不是很清楚了吖，我们整理一下就是：

1.把水煮沸；

2.用沸水冲泡饮料；

3.把饮料倒进杯子；

4.加调料。

大家请注意！大家请注意！主角来了！之前我们已经扔出了概念，所以我们现在可以创建一个抽象父类来表示泡一杯饮料的过程。那么，抽象父类？

## 抽象类？
抽象类是不能被实例化的，一定是用来继承的。继承了抽象类的所有子类都将拥有跟抽象类一致的接口方法，抽象类的主要作用就是为它的子类定义这些公共接口。

通过上面分析，这里具体来说就是要把泡茶和泡咖啡的共同步骤共同点找出来，封装到父类，也就是抽象类中，然后不同的步骤写在子类中，也就是茶和咖啡中。抽象类既然不能被实例化，不怕啊，子类就是他的实例化。

来吧！泡饮料啦！

```js
var Beverage=function(){}
Beverage.prototype.boilWater=function(){
        console.log('把水煮沸');
}
Beverage.prototype.brew=function(){};
Beverage.prototype.pourInCup=function(){};
Beverage.prototype.addCondiments=function(){};
// 抽象方法
Beverage.prototype.init=function(){
    this.boilWater();
    this.brew();
    this.pourInCup();
    this.addCondiments();
}
var Coffee=function(){
    // 将父类的构造方法拿来执行一下
    Beverage.apply(this,arguments);
    // 就像es6的super执行 执行后this才会有对象的属性
}
Coffee.prototype=new Beverage();
var coffee=new Coffee();
coffee.init();
var Tea=function(){

}
Tea.prototype=new Beverage();
Tea.prototype.brew=function(){
    console.log('用沸水浸泡茶叶');
}
Tea.prototype.pourInCup=function(){
    console.log('把茶叶倒进杯子');
}
Tea.prototype.addCondiments=function(){
    console.log('加柠檬');
}
var tea=new Tea();
tea.init();
```

这里既泡了咖啡又泡了茶，是不是没有之前那么繁琐呢，这里的代码可是很高级的呢。

这里用一个父类Beverage来表示Coffee和Tea，然后子类就是后面的Coffee和Tea啦，因为这里的Beverage是一个抽象的存在，需要子类来继承它。泡饮品的流程，可以理解为一个模板模式 ，抽象类Beverage， 抽象方法init()在子类中实现。js的继承是基于原型链的继承，这里prototype就是类的原型链。这里由于coffee对象和tea对象的原型prototype上都没有对应的init(),所以请求会顺着原型链，找到父类Beverage的init()。子类寻找对应的属性和方法的时候会顺着原型链去查找，先找自己，没有找到会顺着去父类里面查找。

Beverage.prototype.init被称为模板方法的原因是，该方法中封装了子类的算法框架，它作为一个算法的模板，指导子类以何种顺序去执行哪些方法。

## 闭包实现模板方法模式
闭包也可以实现的哟，大家对闭包不太理解的可以参考我之前的文章：作用域闭包
```js
var Beverage=function(param){
    // 局部变量
    var boilWater=function(){
       console.log('把水煮沸');
    }
    // 配置
    var brew=param.brew||function(){
        throw new Error('必须传递brew方法');
    }
    var pourInCup=param.pourInCup||function(){
        throw new Error('必须传递pourInCup方法')
    }
    var addCondiments=param.addCondiments||function(){
        throw new Error('必须传递addCondiments方法')
    } 
    var F=function(){};//对象 类
    F.prototype.init=function(){
        boilWater();
        brew();
        pourInCup();
        addCondiments();
    };
    return F;
}
// 传对象
var Coffee=Beverage({
    brew:function(){
        console.log('用沸水泡咖啡');
    },
    pourInCup:function(){
        console.log('把咖啡倒进杯子');
    },
    addCondiments:function(){
        console.log('加糖和牛奶');
    }
})
var coffee=new Coffee(); 
coffee.init();
```
js 把抽象类改为配置类，param将成为Beverage函数里面的闭包函数的引用。Beverage是模板，把他变成一个可以配置的类把参数param传进来，就玩成了配置。这里的配置就是给Beverage传参数，也就是param。F对象规范了类的构成（流程）， 里面的四个私有变量是闭包的。当Beverage new 的时候会new 一个F， 然后就调用了闭包 ，四个私有变量也被调用。

父类里面的brew pourInCup addCondiments方法都是空的，所以子类必须重写。父类里面的那三个方法是如果子类没用重写该方法，就会直接抛出一个异常那个，程序在运行时会得到一个错误。

## 小结
模板方法模式时一种典型的通过封装变化提高系统扩展性的设计模式。运用了模板方法模式的程序中，子类方法种类和执行顺序都是不变的，但是子类的方法具体实现则是可变的。父类是个模板，子类可以添加，就增加了不同的功能。子类和父类之间也就是"尧舜禹"之间的关系，属于同一类，没有血缘关系。