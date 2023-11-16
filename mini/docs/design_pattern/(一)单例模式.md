## 什么是单例模式

单例模式是指在内存中只会创建且仅创建一次对象的设计模式。在程序中多次使用同一个对象且作用相同时，为了防止频繁地创建对象使得内存飙升，单例模式可以让程序仅在内存中创建一个对象，让所有需要调用的地方都共享这一单例对象。

## 特点

1. 类只有一个实例
2. 全局可访问该实例
3. 自行实例化（主动实例化）
4. 可推迟初始化，即延迟执行（与静态类/对象的区别）

## 简单版单例模式

```js
let Singleton = function(name) {
    this.name = name;
    this.instance = null;
}
​
Singleton.prototype.getName = function() {
    console.log(this.name);
}
​
Singleton.getInstance = function(name) {
    if (this.instance) {
        return this.instance;
    }
    return this.instance = new Singleton(name);
}
​
let Winner = Singleton.getInstance('Winner');
let Looser = Singleton.getInstance('Looser');
​
console.log(Winner === Looser); // true
console.log(Winner.getName());  // 'Winner'
console.log(Looser.getName());  // 'Winner'
```
代码中定义了一个 Singleton 函数，函数在 JavaScript 中是“一等公民“，可以为其定义属性方法。因此我们可以在函数 Singleton 中定义一个 getInstance() 方法来管控单例，并创建返回类实例对象，而不是通过传统的 new 操作符来创建类实例对象。

this.instance 存储创建的实例对象，每次接收到创建实例对象时，判断 this.instance 是否有实例对象，有则返回，没有则创建并更新 this.instance 值，因此无论调用多少次 getInstance()，最终都只会返回同一个 Singleton 类实例对象。

### 存在的问题

1. 不够“透明”，无法使用 new 来进行类实例化，需约束该类实例化的调用方式： Singleton.getInstance(...);
2. 管理单例的操作，与对象创建的操作，功能代码耦合在一起，不符合 “单一职责原则”

## 透明版单例模式

实现 “透明版” 单例模式，意图解决：统一使用 new 操作符来获取单例对象， 而不是 Singleton.getInstance(...)。

```js
let CreateSingleton = (function(){
    let instance;
    return function(name) {
        if (instance) {
            return instance;
        }
        this.name = name;
        return instance = this;
    }
})();
CreateSingleton.prototype.getName = function() {
    console.log(this.name);
}
​
let Winner = new CreateSingleton('Winner');
let Looser = new CreateSingleton('Looser');
​
console.log(Winner === Looser); // true
console.log(Winner.getName());  // 'Winner'
console.log(Looser.getName());  // 'Winner'
```
“透明版”单例模式解决了不够“透明”的问题，我们又可以使用 new 操作符来创建实例对象。

## 代理版单例模式

通过“代理”的形式，意图解决：将管理单例操作，与对象创建操作进行拆分，实现更小的粒度划分，符合“单一职责原则”

```js
let ProxyCreateSingleton = (function(){
    let instance;
    return function(name) {
        // 代理函数仅作管控单例
        if (instance) {
            return instance;
        }
        return instance = new Singleton(name);
    }
})();
​
// 独立的Singleton类，处理对象实例
let Singleton = function(name) {
    this.name = name;
}
Singleton.prototype.getName = function() {
    console.log(this.name);
}
​
let Winner = new PeozyCreateSingleton('Winner');
let Looser = new PeozyCreateSingleton('Looser');
​
console.log(Winner === Looser); // true
console.log(Winner.getName());  // 'Winner'
console.log(Looser.getName());  // 'Winner'
```

## 惰性单例模式

惰性单例，意图解决：需要时才创建类实例对象。对于懒加载的性能优化，想必前端开发者并不陌生。惰性单例也是解决 “按需加载” 的问题.

需求：页面弹窗提示，多次调用，都只有一个弹窗对象，只是展示信息内容不同。

开发这样一个全局弹窗对象，我们可以应用单例模式。为了提升它的性能，我们可以让它在我们需要调用时再去生成实例，创建 DOM 节点。

```js
let getSingleton = function(fn) {
    var result;
    return function() {
        return result || (result = fn.apply(this, arguments)); // 确定this上下文并传递参数
    }
}
let createAlertMessage = function(html) {
    var div = document.createElement('div');
    div.innerHTML = html;
    div.style.display = 'none';
    document.body.appendChild(div);
    return div;
}
​
let createSingleAlertMessage = getSingleton(createAlertMessage);
document.body.addEventListener('click', function(){
    // 多次点击只会产生一个弹窗
    let alertMessage = createSingleAlertMessage('您的知识需要付费充值！');
    alertMessage.style.display = 'block';
})
```
代码中演示是一个通用的 “惰性单例” 的创建方式，如果还需要 createLoginLayer 登录框, createFrame Frame框, 都可以调用 getSingleton(...) 生成对应实例对象的方法。

## 适用场景

<strong>`“单例模式的特点，意图解决：维护一个全局实例对象。”`</strong>

1. 引用第三方库（多次引用只会使用一个库引用，如 jQuery）
2. 弹窗（登录框，信息提升框）
3. 购物车 (一个用户只有一个购物车)
4. 全局态管理 store (Vuex / Redux)

项目中引入第三方库时，重复多次加载库文件时，全局只会实例化一个库对象，如 jQuery，lodash，moment ..., 其实它们的实现理念也是单例模式应用的一种：
```js
// 引入代码库 libs(库别名）
if (window.libs != null) {
  return window.libs;    // 直接返回
} else {
  window.libs = '...';   // 初始化
}
```
### vuex种使用
```js
if (!Vue && typeof window !== 'undefined' && window.Vue) {
    install(window.Vue)
}
​
function install (_Vue) {
    if (Vue && _Vue === Vue) {
        console.error('[vuex] already installed. Vue.use(Vuex) should be called only once.')
        return
    }
    Vue = _Vue
}
```
### Message组件

在UI组件库中，Message组件是非常常见的，而且都是支持同时多个展示，那么本次利用单例，将其进行修改为同时只能展示一个，下面的案例以Vue为例

首先常见Message组件的内容

main.vue文件内容：
```js
<template>
    <div v-show="visible">message组件</div>
</template>
​
<script type="text/babel">
export default {
    data() {
        return {
            visible: false
        };
    },
    methods: {
        close() {
            this.visible = false;
        },
        show() {
            this.visible = true;
        }
    }
};
</script>
```
代码内容非常简单，只有一个变量visible和两个函数，控制组件的展示和隐藏

接下来看如何控制其展示.
main.js的内容:
```js
import Vue from "vue";
import Main from "./main.vue";
let MessageConstructor = Vue.extend(Main);
​
class Message {
    /** 
     * 展示 message组件
     */
    show() {
        this.instance.show()
    }
​
    /** 
     * 关闭 message组件
     */
    close() {
        this.instance.close()
    }
    
    /** 
     * 单例
     */
    static getInstance() {
        if(!this.instance) {
            let instance = new MessageConstructor();
            this.instance = instance;
            instance.$mount();
            document.body.appendChild(instance.$el);
        }
​
        return this.instance
    }
}
​
​
Message.getInstance().show();
Message.getInstance().close();
```
无论调用show多少次，展示的都是同一个，因为通过单例模式，使用的都是同一个实例.

### react 单例模式-闭包（ts）

+ 方式一
```js
export const linkFunction = params =>｛
    return (
        new Promise((resolve, reject) => {
            // 重点做个标记
            if (window?.onlyFunc) {
                resolve(window.onlyFunc);
            } else {
                window.addEventListener('listenOnlyFunc', () => {
                    if (window?.onlyFunc) {
                        resolve(window.onlyFunc);
                        window.clearEventListener('listenOnlyFunc', () => {});
                    } else {
                        reject(new Error('方法未注册'));
                    }
                })
            }
        })
    )
}.then(onlyFunc => onlyFunc.handle());
```
+ 方式二
```ts
    const Singleton (function () {
    let instance: null | Promise<any> = null;
    function createInstance() {
        return new Promise((resolve, reject) => {
            if (window?.onlyFunc) {
                resolve(window.onlyFunc);
                window.clearEventListener('listenOnlyFunc', () => {});
            } else {
                reject(new Error('方法未注册'));
            }
        });
    }
    ​
    function getInstance() {
        if (!instance) {
            instance = createInstance()
        }
        return instance;
    }
    return {instance}
})()
​
export useSingle = () => {
    return Singleton.getInstance().then(onlyFunc => onlyFunc.handle())
}
```
### react 单例模式-class(ts)

+ 方式一

```ts
class Singleton {
    static instance: null | Promise<any> = null;
    ​
    private static createInstance() {
        return new Promise((resolve, reject) => {
            // 和上面基本一样
            if (window?.onlyFunc) {
                resolve(window.onlyFunc);
                window.clearEventListener('listenOnlyFunc', () => {});
            } else {
                reject(new Error('方法未注册'));
            }
        });
    }
    ​
    static getInstance() {
        if (!Singleton.instance) {
            Singleton.instance = Singleton.createInstance
        }
        return Singleton.instance;
    }
}
export useSingle = () => {
    return Singleton.getInstance().then(onlyFunc => onlyFunc.handle())
}
```

+ 方式二

```js
import React from 'react'
import { render, unmountComponentAtNode } from 'react-dom'
//具体单例类代码
export default class Singleton {
    constructor(component){
        this.dom = null;
        this.component = component;
        this.instance = null;
    }
    ​
    render(option) {
        if(!this.dom) {
            this.dom = document.createElement('div');
            document.body.appendChild(this.dom);
        }
        this.instance = ReactDOM.render(<this.component {...option}/>, this.dom);
    }
    ​
    destroy() {
        unmountComponentAtNode(this.dom);
    }
}
​
//使用例子
//在适当地方调用如下代码渲染组件
new Singleton(Component).show();
```

## 优缺点

+ 优点：适用于单一对象，只生成一个对象实例，避免频繁创建和销毁实例，减少内存占用。
+ 缺点：不适用动态扩展对象，或需创建多个相似对象的场景.