## 用法

```js
_.slice(array, [start=0], [end=array.length])
```
+ 结果
    裁剪数组array，从 start 位置开始到end结束，但不包括 end 本身的位置。

        Note: 这个方法用于代替Array#slice 来确保数组正确返回。

+ 参数
    array (Array): 要裁剪数组。
    [start=0] (number): 开始位置。
    [end=array.length] (number): 结束位置。
+ 返回
    (Array): 返回 数组array 裁剪部分的新数组。

## 源码

```js
/**
 * Creates a slice of `array` from `start` up to, but not including, `end`.
 *
 * **Note:** This method is used instead of
 * [`Array#slice`](https://mdn.io/Array/slice) to ensure dense arrays are
 * returned.
 *
 * @since 3.0.0
 * @category Array
 * @param {Array} array The array to slice.
 * @param {number} [start=0] The start position. A negative index will be treated as an offset from the end.
 * @param {number} [end=array.length] The end position. A negative index will be treated as an offset from the end.
 * @returns {Array} Returns the slice of `array`.
 * @example
 *
 * var array = [1, 2, 3, 4]
 *
 * _.slice(array, 2)
 * // => [3, 4]
 */
function slice(array, start, end) {
    let length = array == null ? 0 : array.length;
    if (!length) {
        return [];
    }
    start = start == null ? 0 : start;
    end = end === undefined ? length : end;

    if (start < 0) {
        start = -start > length ? 0 : length + start;
    }
    end = end > length ? length : end;
    if (end < 0) {
        end += length;
    }
    length = start > end ? 0 : (end - start) >>> 0;
    start >>>= 0;

    let index = -1;
    const result = new Array(length);
    while (++index < length) {
        result[index] = array[index + start];
    }
    return result;
}

export default slice;
```

## 解析

我们可以看到，代码也是非常简介，整个方法并没有引用其他的方法。最开始，因为该方法有三个参数，所以，我们先对不正确参数做处理，将length，start,end初始化成我们想要的结果。然后声明了一个result的新数组，来存放结果，然后通过一个while循环，将原数组中的元素循环放入到result中，这就是lodash的slice方法。