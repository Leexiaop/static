## 用法

```js
_.hasIn(object, path)
```
+ 结果
    检查 path 是否是object对象的直接或继承属性。
    
+ 参数
    1. object (Object): 要检索的对象。
    2. path (Array|string): 要检查的路径path。

+ 返回
    (boolean): 如果path存在，那么返回 true ，否则返回 false。

+ 例子
    ```js
        var object = _.create({ 'a': _.create({ 'b': 2 }) });
        
        _.hasIn(object, 'a');
        // => true
        
        _.hasIn(object, 'a.b');
        // => true
        
        _.hasIn(object, ['a', 'b']);
        // => true
        
        _.hasIn(object, 'b');
        // => false
    ```

## 源码

```js
/**
 * Checks if `path` is a direct or inherited property of `object`.
 *
 * @since 4.0.0
 * @category Object
 * @param {Object} object The object to query.
 * @param {string} key The key to check.
 * @returns {boolean} Returns `true` if `key` exists, else `false`.
 * @see has, hasPath, hasPathIn
 * @example
 *
 * const object = create({ 'a': create({ 'b': 2 }) })
 *
 * hasIn(object, 'a')
 * // => true
 *
 * hasIn(object, 'b')
 * // => false
 */
function hasIn(object, key) {
    return object != null && key in Object(object);
}

export default hasIn;
```

## 解析

重点看源码，只有一句话，当判断的对象不是null的时候，实用Javascript的in语法来判断即可得出结果。

`注`：in操作符就是用来判断一个属性是否真的存在于一个对象中，如果存在，那么就返回true,否则返回false.
+ 对象，包括原型上均返回true
```js
var obj = {
    name: '张三'
}
console.log('name' in obj)  //  true
console.log('age' in obj)   //  false
obj._proto_.age = 33
console.log('age' in obj)   //  true
```
+ 判断数组中的索引
```js
var arr = [1]
console.log(1 in arr)   //  false, 这里的1是Arr的索引
console.log(0, in arr)  //  true
```