---
title: 203.移除链表元素
order: 203
---

`难度：`简单

`题目：`给你一个链表的头节点 head 和一个整数 val ，请你删除链表中所有满足
Node.val == val 的节点，并返回 新的头节点 。

`思路：`递归

-   递归整条链表，如果发现某个节点的 val 等于题中给的 val，那么就将当前节点的指
    针指向下下个节点

`答案：`

```js
/**
 * Definition for singly-linked list.
 * function ListNode(val, next) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.next = (next===undefined ? null : next)
 * }
 */
/**
 * @param {ListNode} head
 * @param {number} val
 * @return {ListNode}
 */
var removeElements = function (head, val) {
	if (!head) return head;
	head.next = removeElements(head.next, val);
	return head.val === val ? head.next : head;
};
```
