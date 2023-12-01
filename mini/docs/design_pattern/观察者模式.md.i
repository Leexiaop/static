观察者模式又叫做发布-订阅模式。这是一种一对多的对象依赖关系，当被依赖的对象的状态发生改变时，所有依赖于它的对象都将得到通知。

## 生活中的观察者模式

就如我们在专卖店预定商品（如：苹果手机），我们会向专卖店提交预定申请，然后店家受申请，正常这样就完事了。假如，近段时间苹果手机的需求很大，而商品有限，那么商家就会要这些果粉预留电话等待通知，等到手机一到，商家就会遍历果粉预留信息，然后发通知给这些果粉。生活中商家强调客户在家等通知即可，并且说一有消息就会通知客户，而不会傻到要客户主动打电话询问，这样不仅客户的代价比较大，商家的负荷更大，用户的轮询方式也从打电话变成了查看短信息

## 观察者模式的优势
发布和订阅这两个对象是松耦合地联系在一起的，它们不用彼此熟悉内部的实现细节，但这不影响它们之间的通信，它们只要知道彼此需要做什么就行。当有新订阅者增加时，发布者不需要任何更改，同样的当发布者改变时，订阅者也不会受到影响。

就像新闻联播一样里面的央视主持人换了，也不影响我们看央视的新闻联播，同样你看或不看新闻联播，对央视来说也无影响。

在异步通信中观察者模式也是大有好处，发布者只需按顺序的发布事件即可，而订阅者只需在异步运行期间订阅相关事件即可。

## JavaScript中的观察者模式

在JavaScript中观察者模式的实现主要用事件模型。

## DOM事件

```js
document.body.addEventListener('click', function() {
    console.log('hello world!');
});

```
相信这样的代码不少的同学都写过，但我要说这其实就是一种观察者模式的实现，可能一些童鞋还不信，那么看一看修改后的代码。

```js
// 发布者
var pub = function() {
    console.log('欢迎订阅!')
}
// 订阅者
var sub = document.body;

// 订阅者实现订阅
sub.addEventListener('click', pub, false);
```
订阅者可以任意的添加，发布者也可以随意的修改。

虽然，使用dom事件可以轻松解决我们开发中的一部分问题；但是还有一些问题需要我们使用自定义事件来完成。
那面就说一说如何用自定义事件实现代理。

我们还以预定手机为例，参考dom事件的原理来实现观察者模式，用用户的电话号码作为类型，用户的定购信息用一个回调函数来表示。

基本概念定义如下：

+ 商家： 发布者
+ 客户： 订阅者
+ 缓存列表：记录客户的电话，方便商家遍历发通知消息给客户
注：缓存列表，我将它定义为一个对象，用户的电话号码作为key，用户的预定信息是个数组作为value。

代码实现如下：

```js
// 定义商家
var merchants = {};
// 定义预定列表
merchants.orderList = {};
// 将增加的预订者添加到预定客户列表中
merchants.listen = function(id, info) {
    if(!this.orderList[id]) {
        this.orderList[id] = [];
    }
    this.orderList[id].push(info);
    console.log('预定成功')
};
//发布消息
merchants.publish = function() {
    var id = Array.prototype.shift.call(arguments);
    var infos = this.orderList[id];
    // 判断是否有预订信息
    if(!infos || infos.length === 0) {
        console.log('您还没有预订信息!');
        return false;
    }
    // 如果有预订信息，则循环打印
    for (var i = 0, info; info = infos[i++];) {
        console.log('尊敬的客户：');
        info.apply(this, arguments);
        console.log('已经到货了');
    }
};
// 定义一个预订者customerA，并指定预定信息
var customerA = function() {
    console.log('黑色至尊版一台');
};
// customerA 预定手机，并留下预约电话
merchants.listen('15888888888', customerA); // 预定成功
// 商家发布通知信息
merchants.publish('15888888888');
/**
   尊敬的客户：
   黑色至尊版一台
   已经到货了
 */
```

## 取消订阅

当然，现实中我们可以预定，那么也可以取消预定。其实取消预定的方式也比较简单，就是将客户从预定列表中清除出去。代码实现如下：

```js
merchants.remove = function(id, fn) {
    var infos = this.orderList[id];

    if(!infos) return false;

    if(!fn) {
        infos && (infos.length = 0);
    } else {
        for(var i = 0, len = infos.length; i < len; i++) {
            if(infos[i] === fn) {
                infos.splice(i, 1);
            }
        }
    }
};
merchants.remove('15888888888', customerA);
merchants.publish('15888888888'); // 您还没有预订信息!
```
## 全局的观察者模式

实现的代码结构如下：

```js
var observer = (function() {
    var orderList = {},
        listen,
        publish,
        remove;
    listen = function(id, fn) {
        ...
    };

    publish = function() {
        ...
    };

    remove = function(id, fn) {
        ...
    };

    return {
        listen: listen,
        publish: publish,
        remove: remove
    }
})();
```

+ 优点：

使用了全局的观察者模式后，我们不用管商家是谁，只要他能提供我们所需要的东西即可；而且我们也避免了为不同的商家都创建listen，publish，remove方法，这样可以减少资源的浪费。

+ 缺点：

使用全局的观察者模式会明显降低对象之间的联系。一些方法将会被隐藏，而有时我们恰恰需要这些方法的暴露。

+ 是先订阅，还是先发布

在我被问到这个问题时，我也是一愣，当时脑袋里就冒出了‘你怎么不问是先有鸡，还是先有蛋’这样的想法。

按照我的理解我们实现观察者模式，都是订阅者先订阅，然后接收发布者的通知消息。没有反过来想，发布者先发布一条消息，然后等订阅者接收，因为在我的想象中，如果没有订阅者，这消息怎么成功发布。

后来有人跟我说有这样的业务实现，当时我就不假思索的问什么业务，他说QQ的离线模式。这种先发布后订阅的形式是将信息先存储起来，等到订阅者订阅，就立即将信息发送给订阅者。如：当我们将QQ调到离线模式，我们就无法接收信息；当我们将QQ调到登录模式，就马上收在离线模式期间接收到的信息。

这样的例子在生活中也有很多，还拿天气预报，它也可以理解为是先发布，我们后订阅的模式。天预报信息会发布在网上，存储在各个服务器上，我们需要时打开手机就可以得到。

注：提到观察者模式我们就不得不说一下推模型和拉模型。推模型在事件发生时，发布者会将变化状态和数据都推送给订阅者；拉模型在事件发生时，发布者只会给订阅者一个状态改变通知，订阅者会根据发布者提供的接口主动拉取数据。