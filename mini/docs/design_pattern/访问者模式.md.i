## 定义
访问者模式，针对于对象结构中的元素，定义在不改变该对象的前提下访问其结构中元素的新方法。

```js

// 访问者模式：DOM事件绑定
var bindEvent = function(dom, type, fn, data) {
    if (dom.addEventListener) {
        dom.addEventListener(type, fn, false);
    } else if (dom.attachEvent) {
        // dom.attachEvent('on'+type, fn);
        var data = data || {};
        dom.attachEvent('on' + type, function(e) {
            // 在IE中this指向 window，使用call改变this的指向
            fn.call(dom, e, data);
        });
    } else {
        dom['on' + type] = fn;
    }
}
function $(id) {
    return document.getElementById(id);
}
​
bindEvent($(demo), 'click', function() {
    // this 指向dom对象
    this.style.background = 'red';
});
​
bindEvent($('btn'), 'click', function(e, data) {
    $('text').innerHTML = e.type + data.text + this.tagName;
}, { text: 'demo' });
```

访问者模式的思想就是在不改变操作对象的同时，为它添加新的操作方法，以实现对操作对象的访问。我们知道，call 和 apply 的作用就是更改函数执行时的作用域，这正是访问者模式的精髓。通过 call、apply 这两种方式我们就可以让某个对象在其它作用域中运行。

```js
var Visitor = (function() {
    return {
        splice: function() {
            var args = Array.prototype.splice.call(arguments, 1);
            return Array.prototype.splice.apply(arguments[0], args);
        },
        push: function() {
            var len = arguments[0].length || 0;
            var args = this.splice(arguments, 1);
            arguments[0].length = len + arguments.length - 1;
            return Array.prototype.push.apply(arguments[0], args);
        },
        pop: function() {
            return Array.prototype.pop.apply(arguments[0]);
        }
    }
})();
​
var a = new Object();
Visitor.push(a,1,2,3,4);
Visitor.push(a,4,5,6);
Visitor.pop(a);
Visitor.splice(a,2);
```

## 总结
访问者模式解决了数据与数据的操作方法之间的耦合，让数据的操作方法独立于数据，使其可以自由演变。因此，访问者模式更适合于那些数据稳定、但数据的操作方法易变的环境下。

当操作环境改变时，可以自由修改数据的操作方法，实现操作方法的拓展，以适应新的操作环境，而无须修改原数据。如此，对于同一个数据，它可以被多个访问对象所访问，这极大地增加了数据操作的灵活性。