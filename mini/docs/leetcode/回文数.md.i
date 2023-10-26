`难度：`简单

`题目：`给你一个整数 x ，如果 x 是一个回文整数，返回 true ；否则，返回 false 。
回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。

`思路：`

-   将整数转为字符串
-   将字符串颠倒
-   比较原字符串和颠倒后的字符串是否相等

`答案：`

```js
/**
 * @param {number} x
 * @return {boolean}
 */
var isPalindrome = function (x) {
	x = x.toString();
	let y = '';
	for (let i = x.length - 1; i >= 0; i--) {
		y += x[i];
	}
	return y === x;
};
```

`解析：`

const num = -121;

-   num 转成字符串，此时 num="-121";
-   循环将 num 颠倒，此时 num="121-";
-   比较俩个字符串是否相等，结果发现不想等，返回 false;
