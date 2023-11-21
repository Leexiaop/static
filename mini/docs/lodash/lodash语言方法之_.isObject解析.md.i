## 用法

```js
_.isObject(value)
```
+ 结果
    检查 value 是否为 Object 的language type。 (例如： arrays, functions, objects, regexes,new Number(0), 以及 new String(''))
    
+ 参数
    value (*): 要检查的值。

+ 返回
    (boolean): 如果 value 为一个对象，那么返回 true，否则返回 false。

+ 例子
    ```js
         _.isObject({});
        // => true
        
        _.isObject([1, 2, 3]);
        // => true
        
        _.isObject(_.noop);
        // => true
        
        _.isObject(null);
        // => false
    ```

## 源码

```js
/**
 * Checks if `value` is the
 * [language type](http://www.ecma-international.org/ecma-262/7.0/#sec-ecmascript-language-types)
 * of `Object`. (e.g. arrays, functions, objects, regexes, `new Number(0)`, and `new String('')`)
 *
 * @since 0.1.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is an object, else `false`.
 * @example
 *
 * isObject({})
 * // => true
 *
 * isObject([1, 2, 3])
 * // => true
 *
 * isObject(Function)
 * // => true
 *
 * isObject(null)
 * // => false
 */
function isObject(value) {
    const type = typeof value;
    return value != null && (type === 'object' || type === 'function');
}

export default isObject;
```

## 解析

看代码，还需要解释吗，如此的简单，通过typeof 和value !== null，排除了基本类型，那么剩余的就都认为是对象。

