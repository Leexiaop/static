## 用法

```js
_.after(n, func)
```
+ 结果
    _.before的反向函数;此方法创建一个函数，当他被调用n或更多次之后将马上触发func 。

+ 参数
    1. n (number): func 方法应该在调用多少次后才执行。
    2. func (Function): 用来限定的函数。

+ 返回
    (Function): 返回新的限定函数。

+ 例子
    ```js
        var saves = ['profile', 'settings'];
 
        var done = _.after(saves.length, function() {
        console.log('done saving!');
        });
        
        _.forEach(saves, function(type) {
        asyncSave({ 'type': type, 'complete': done });
        });
        // => Logs 'done saving!' after the two async saves have completed.
    ```

## 源码

```js
/**
 * The opposite of `before`. This method creates a function that invokes
 * `func` once it's called `n` or more times.
 *
 * @since 0.1.0
 * @category Function
 * @param {number} n The number of calls before `func` is invoked.
 * @param {Function} func The function to restrict.
 * @returns {Function} Returns the new restricted function.
 * @example
 *
 * const saves = ['profile', 'settings']
 * const done = after(saves.length, () => console.log('done saving!'))
 *
 * forEach(saves, type => asyncSave({ 'type': type, 'complete': done }))
 * // => Logs 'done saving!' after the two async saves have completed.
 */
function after(n, func: Function) {
    if (typeof func !== 'function') {
        throw new TypeError('Expected a function');
    }
    n = n || 0;
    // eslint-disable-next-line consistent-return
    return function (this: any, ...args: any[]) {
        if (--n < 1) {
            return func.apply(this, args);
        }
    };
}

export default after;
```

## 解析

根据代码，我们可以看到，和她得用法一样，首先就是判断了func参数是不是一个方法，然后返回了一个新得函数，仅此而已。

