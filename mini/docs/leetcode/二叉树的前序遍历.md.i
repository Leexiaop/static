---
title: 144.二叉树的前序遍历
order: 144
---

`难度：`简单

`题目：`给定一个二叉树的根节点 root ，返回 它的 前序 遍历 。

`思路：`递归

-   前序遍历的顺序是根节点——左子树——右子树，所以按照这个顺序通过递归的方法来遍历
    即可

`答案：`

```js
/**
 * Definition for a binary tree node.
 * function TreeNode(val, left, right) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.left = (left===undefined ? null : left)
 *     this.right = (right===undefined ? null : right)
 * }
 */
/**
 * @param {TreeNode} root
 * @return {number[]}
 */
var inorderTraversal = function (root) {
	let res = [];
	let fun = (node) => {
		if (!node) return;
		res.push(node.val);
		node.left && fun(node.left);
		node.right && fun(node.right);
	};
	fun(root);
	return res;
};
```
