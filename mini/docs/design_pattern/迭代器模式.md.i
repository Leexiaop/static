迭代器模式：一个相对简单的模式，目前绝大多数语言都内置了迭代器，以至于大家都不觉得这是一种设计模式。

## 迭代器模式
迭代器模式指提供一种方法访问一个聚合对象中的各个元素，而又不需要暴露该对象的内部表示。个人理解成遍历聚合对象中的各个（某些）元素，并执行一个回调方法，如今大多数语言都已经内置了迭代器，但这里记录一下，理解其中的实现目的。

### jQuery 中的$.each

```js
$.each([1,2,3,4,5], function(i, el) {
    console.log('index: ',i)
    console.log('item: ', el)
})
```
如何自定义一个each函数，实现以上的效果呢？
```js
var each = function (arr, callback) {
    for (var i = 0, len = arr.length; i<len; i++) {
        callback.call(arr[i], i, arr[i])
    }
}

each([1,2,3,4,5], function(i, el) {
    console.log('index: ',i)
    console.log('item: ', el)
})
```
这里实现了一个较为简单的内部迭代器方法，然而迭代器同时还有一种类似——外部迭代器.
## 内部迭代器和外部迭代器

### 内部迭代器

如刚刚自定义个each方法，这种迭代器在内部已经定义好了迭代规则，如，迭代的方向，迭代是否在满足条件是中止。

内部迭代器在调用时非常方便，外界不用去关心其内部的实现。在每一次调用时，迭代器的规则就已经制定，如果遇到一些不同样的迭代规则，此时的内部迭代器并不很优雅

like this:
```js
// 当需要同时迭代两个数组时

var compare = function(ary1, ary2) {
    if (ary1.length !== ary2.length) {
        throw new Error ('ary1 和 ary2 不相等')
    }
    
    each(ary1, function(i, n){
        if (n !== ary2[i]) {
            throw new Error ('ary1 和 ary2 不相等')
        }
    })
    alert ('ary1, ary2相等')
}

compare([1,2,3,4], [2,3,4,5,6])
```
但如果用外部迭代器来实现一个这样的需求时，就显得更加清晰易懂.

### 外部迭代器

外部迭代器必须显示地请求迭代下一个元素（ltertor.next()）

外部迭代器虽然增加了调用的复杂度，但增强了迭代器的灵活性，我们可以手工控制迭代过程或者顺序。Generators 应该就是一种外部迭代器的实现。那么接下来看看如何自己实现一个外部迭代器：

```js
var Iterator = function(obj) {
    var current = 0
    var next = function() {
        current += 1
    }
    var isDone = function() {
        return current >= obj.lenght
    }
    var getCurrent = function() {
        return obj[current]
    }
    return {
        next: next,
        length: obj.length,
        isDone:isDone,
        getCurrent:getCurrent
    }
}
```
通过这个迭代器，我们就可以更加优雅的实现刚刚的compare方法来迭代两个数组了：

```js
var compare = function(iteraotr1, iteraotr2) {
    if (iteraotr1.length !== iteraotr2.length) {
        alert('不相等')
    }
    //外部设定条件来决定迭代器的进行
    while (!iteraotr1.isDone() && !iteraotr2.isDone()) {
        if (iteraotr1.getCurrent() !== iteraotr2.getCurrent()) {
            alert('不相等')
        }
        iteraotr1.next()
        iteraotr2.next()
    }
    alert('相等')
}

var iteraotr1 = Iterator([1,2,3])
var iteraotr2 = Iterator([1,2,3])

compare(iteraotr1,iteraotr2) // 相等
```
通过外部迭代器，较为优雅的实现了这个同时迭代两个数组的需求。但实际中，内部迭代器和外部迭代器两者并无优劣。具体使用何种，需更具实际情况来决定。

### 迭代器并不只迭代数组

迭代器模式不仅能迭代数组，还可以迭代一些类数组对象。比如arguments，{a:1,n:2,c:3}等。其须具备的就是对象拥有一个length属性可以访问，并能通过下标来访问对象中的各个元素。

其中for ... of 可以来循环数组，对象字面量则可以通过for ... in来访问其中的各个属性的值来达到目的。

### 迭代器可以中止
在for循环中，我们可以通过break来跳出循环，所以在迭代器模式中。我们可以利用这个来提前终止迭代。接下来我们改在一下最开始的each函数。
```js
var each = function(arr, callback) {
    var result
    for (var i = 0, len = arr.length; i < len; i++) {
        result = callback.call(arr[i], i, arr[i])
        if (result === false) {
            break
        }
    }
}

each([1,2,3,4,5,6,7], function(i, el) {
    if (el > 3) {
        return false
    }
    console.log(el)
})
```

## 最后

迭代器模式的实现原理较为简单，JavaScript中有更多针对不同需求的迭代器实现。我们也可以自己定义一个适合的规则来处理数组，类数组这样的对象。但往往最常见的也是最容易被忽视的，而一个常见的东西往往是更好用更受用的。