---
title: 67.二进制求和
order: 67
---

`难度：`简单

`题目：`给你两个二进制字符串 a 和 b ，以二进制字符串的形式返回它们的和。

`思路：`

-   先找到俩个字符串比较短的一个用 0 补齐，使得俩个字符串的长度一样，然后从后向
    前遍历

`答案：`

```js
/**
 * @param {string} a
 * @param {string} b
 * @return {string}
 */
var addBinary = function (a, b) {
	let ans = '';
	let ca = 0;
	for (let i = a.length - 1, j = b.length - 1; i >= 0 || j >= 0; i--, j--) {
		let sum = ca;
		sum += i >= 0 ? parseInt(a[i]) : 0;
		sum += j >= 0 ? parseInt(b[j]) : 0;
		ans += sum % 2;
		ca = Math.floor(sum / 2);
	}
	ans += ca == 1 ? ca : '';
	return ans.split('').reverse().join('');
};
```
