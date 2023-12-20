## 用法

```js
_.before(n, func)
```
+ 结果
    创建一个调用func的函数，通过this绑定和创建函数的参数调用func，调用次数不超过 n 次。 之后再调用这个函数，将返回一次最后调用func的结果。   

+ 参数
    1. n (number): 超过多少次不再调用func（注：限制调用func 的次数）。
    2. func (Function): 限制执行的函数。

+ 返回
    (Function): 返回新的限定函数。

+ 例子
    ```js
        jQuery(element).on('click', _.before(5, addContactToList));
        // => allows adding up to 4 contacts to the list
    ```

## 源码

```js
/**
 * Creates a function that invokes `func`, with the `this` binding and arguments
 * of the created function, while it's called less than `n` times. Subsequent
 * calls to the created function return the result of the last `func` invocation.
 *
 * @since 3.0.0
 * @category Function
 * @param {number} n The number of calls at which `func` is no longer invoked.
 * @param {Function} func The function to restrict.
 * @returns {Function} Returns the new restricted function.
 * @example
 *
 * jQuery(element).on('click', before(5, addContactToList))
 * // => Allows adding up to 4 contacts to the list.
 */
function before(n, func) {
    let result;
    if (typeof func !== 'function') {
        throw new TypeError('Expected a function');
    }
    return function (...args) {
        if (--n > 0) {
            result = func.apply(this, args);
        }
        if (n <= 1) {
            func = undefined;
        }
        return result;
    };
}

export default before;
```

## 解析

根据代码，我们可以看到，和她得用法一样，首先就是判断了func参数是不是一个方法，然后返回了一个新得函数，仅此而已。

