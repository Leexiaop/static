### 什么是适配器模式

适配器模式是用来解决两个接口不兼容的情况，不需要改变已有的接口，通过包装一层的方式，实现两个接口正常协作。当我们试图调用模块或者对象的某个接口时，却发现这个接口的格式并不符合目前的需求, 则可以用适配器模式。

### 适配器模式生活实例

+ 插头转换器
+ 电源插座
+ USB转接头

### 代码示例
```js
//  1.日常数据处理，传入指定的数据然后按照指定规则输出我们期待得到的数据格式
const arr = [
    {
        type: '男装',
        quantity: 500
    },
    {
        type: '女装',
        quantity: 600
    },
    {
        type: '鞋子',
        quantity: 550
    }
]
const xAxisAdapter = (arr) => {
    return arr.map(item=>item.type)
} 
const yAxisAdapter = (arr) => {
    return arr.map(item=>item.quantity)
}
​
//  2.事件绑定兼容各浏览器
function addEvent(ele, event, callback) {
    if (ele.addEventListener) {
        ele.addEventListener(event, callback)
    } else if(ele.attachEvent) {
        ele.attachEvent('on' + event, callback)
    } else {
        ele['on' + event] = callback
    }
}
​
//  3.vue的计算属性
<template>
    <div id="app">
        <div>{{ reverseMsg }}</div>
    </div>
</template>
const vm = new Vue({
    el: '#app',
    data() {
        return {
        msg: 'gfedcba'
        }
    },
    computed: {
        reverseMsg() {
        return this.msg.split('').reverse().join('')
        }
    }
})
var obj = {
    name: "你我贷",
    job: "前端"
}
function Person() {
​
}
var person = new Person()
person.showInfo = function (name,job) {
    console.log(name + ' is ' + name + ' and job is ' + job);
}
person.showInfo(obj.name,obj.job);
```
### jQuery中的适配器

上面提到的适配器写法只是表现了适配器是一个什么样的东西，但实际项目中不会出现这样的代码。我们以jQuery中的一个API为例，说说实际应用中的适配器模式的使用方法。

在jQuery样式相关的API中，最方便使用的就是css()了，这个接口是把set和get的功能合二为一了：

```js
// 既可以像这样调用，取得opacity值
$('.elem').css('opacity');
​
// 也可以像这样，设置opacity值
$('.elem').css({'opacity': '0.9'});
```
### 使用场景
    + 使用一个已经存在的对象，但其方法或属性不符合我们的要求。
    + 统一多个类的接口设计
    + 适配不同格式的数据
    + 兼容老版本的接口
#### 优缺点
+ 优点
    + 可以将接口或数据转换代码从程序主要业务逻辑中分离
    + 已有的功能如果只是接口不兼容，使用适配器适配已有功能，可以使原有逻辑得到更好的复用，有助于避免大规模改写现有代码
    + 灵活性好，适配器并没有对原有对象的功能有所影响，不想使用适配器时直接删掉适配器代码即可，不会对使用原有对象的代码有影响
+缺点
    + 过多使用适配器，会使系统非常零乱，代码复杂度增加

## 与其他模式的关系

+ 适配器模式主要用来解决两个已有接口之间不匹配的问题，它不考虑这些接口是怎样实现的，也不考虑它们将来可能会如何演化。适配器模式不需要改变已有的接口，就能够使它们协同作用。
+ 装饰者模式和代理模式也不会改变原有对象的接口，但装饰者模式的作用是为了给对象增加功能。装饰者模式常常形成一条长的装饰链，而适配器模式通常只包装一次。代理模式是为了控制对对象的访问，通常也只包装一次。
+ 外观模式的作用倒是和适配器比较相似，有人把外观模式看成一组对象的适配器，但外观模式最显著的特点是定义了一个新的接口。
