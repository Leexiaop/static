---
title: 171.Excel的表列序号
order: 171
---

`难度：`简单

`题目：`给你一个字符串 columnTitle ，表示 Excel 表格中的列名称。返回 该列名称对
应的列序号 。

`思路：`

-   从右到左每个字母代表的数值是单个字母的序号乘以 26 的 0 次方， 1 次方，2 次方
    ......

`答案：`

```js
/**
 * @param {string} columnTitle
 * @return {number}
 */
var titleToNumber = function (s) {
	let result = 0;
	for (let i = 0, len = s.length; i < len; i++) {
		result += (s[i].charCodeAt() - 64) * 26 ** (len - i - 1);
	}
	return result;
};
```
