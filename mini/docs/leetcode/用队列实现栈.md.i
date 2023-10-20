---
title: 225.用队列实现栈
order: 225
---

`难度：`简单

`题目：`请你仅使用两个队列实现一个后入先出（LIFO）的栈，并支持普通栈的全部四种操
作（push、top、pop 和 empty）。实现 MyStack 类：

-   void push(int x) 将元素 x 压入栈顶。
-   int pop() 移除并返回栈顶元素。
-   int top() 返回栈顶元素。
-   boolean empty() 如果栈是空的，返回 true ；否则，返回 false 。

注意：

-   你只能使用队列的基本操作 —— 也就是  push to back、peek/pop from front、size
    和  is empty  这些操作。
-   你所使用的语言也许不支持队列。  你可以使用 list （列表）或者 deque（双端队列
    ）来模拟一个队列  , 只要是标准的队列操作即可。

`答案：`

```js
var MyStack = function () {
	this.queue1 = [];
	this.queue2 = [];
};

/**
 * @param {number} x
 * @return {void}
 */
MyStack.prototype.push = function (x) {
	this.queue1.push(x);
};

/**
 * @return {number}
 */
MyStack.prototype.pop = function () {
	while (this.queue1.length > 1) {
		this.queue2.push(this.queue1.shift());
	}
	let ans = this.queue1.shift();
	while (this.queue2.length) {
		this.queue1.push(this.queue2.shift());
	}
	return ans;
};

/**
 * @return {number}
 */
MyStack.prototype.top = function () {
	return this.queue1.slice(-1)[0];
};

/**
 * @return {boolean}
 */
MyStack.prototype.empty = function () {
	return !this.queue1.length;
};

/**
 * Your MyStack object will be instantiated and called as such:
 * var obj = new MyStack()
 * obj.push(x)
 * var param_2 = obj.pop()
 * var param_3 = obj.top()
 * var param_4 = obj.empty()
 */
```
