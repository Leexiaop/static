命令模式：请求以命令的形式包裹在对象中，并传给调用对象。调用对象寻找可以处理该命令的合适的对象，并把该命令传给相应的对象，该对象执行命令。

## 模式特点

命令模式由三种角色构成：

1. 发布者 invoker（发出命令，调用命令对象，不知道如何执行与谁执行）；
2. 接收者 receiver (提供对应接口处理请求，不知道谁发起请求）；
3. 命令对象 command（接收命令，调用接收者对应接口处理发布者的请求）。

发布者 invoker 和接收者 receiver 各自独立，将请求封装成命令对象 command ，请求的具体执行由命令对象 command 调用接收者 receiver 对应接口执行。

命令对象 command 充当发布者 invoker 与接收者 receiver 之间的连接桥梁（中间对象介入）。实现发布者与接收之间的解耦，对比过程化请求调用，命令对象 command 拥有更长的生命周期，接收者 receiver 属性方法被封装在命令对象 command 属性中，使得程序执行时可任意时刻调用接收者对象 receiver 。因此 command 可对请求进行进一步管控处理，如实现延时、预定、排队、撤销等功能。

## 代码实现

```js
class Receiver {  // 接收者类
  execute() {
    console.log('接收者执行请求');
  }
}

class Command {   // 命令对象类
  constructor(receiver) {
    this.receiver = receiver;
  }
  execute () {    // 调用接收者对应接口执行
    console.log('命令对象->接收者->对应接口执行');
    this.receiver.execute();
  }
}

class Invoker {   // 发布者类
  constructor(command) {
    this.command = command;
  }
  invoke() {      // 发布请求，调用命令对象
    console.log('发布者发布请求');
    this.command.execute();
  }
}

const warehouse = new Receiver();       // 仓库
const order = new Command(warehouse);   // 订单
const client = new Invoker(order);      // 客户
client.invoke();

/*
输出：
  发布者发布请求
  命令对象->接收者->对应接口执行
  接收者执行请求
*/
```

## 应用场景

有时候需要向某些对象发送请求，但是并不知道请求的接收者是谁，也不知道被请求的操作是什么。需要一种松耦合的方式来设计程序，使得发送者和接收者能够消除彼此之间的耦合关系。
1. 不关注执行者，不关注执行过程；
2. 只要结果，支持撤销请求、延后处理、日志记录等。

## 优缺点
### 优点：
1. 发布者与接收者实现解耦；
2. 可扩展命令，对请求可进行排队或日志记录。（支持撤销，队列，宏命令等功能）。


### 缺点：
1. 额外增加命令对象，非直接调用，存在一定开销。

## 宏命令
    
    宏命令：一组命令集合（命令模式与组合模式的产物）

发布者发布一个请求，命令对象会遍历命令集合下的一系列子命令并执行，完成多任务。

```js
// 宏命令对象
class MacroCommand {
  constructor() {
    this.commandList = [];  // 缓存子命令对象
  }
  add(command) {            // 向缓存中添加子命令
    this.commandList.push(command);
  }
  exceute() {               // 对外命令执行接口
    // 遍历自命令对象并执行其 execute 方法
    for (const command of this.commandList) {
      command.execute();
    }
  }
}

const openWechat = {  // 命令对象
  execute: () => {
    console.log('打开微信');
  }
};

const openChrome = {  // 命令对象
  execute: () => {
    console.log('打开Chrome');
  }
};

const openEmail = {   // 命令对象
  execute: () => {
    console.log('打开Email');
  }
}

const macroCommand = new MacroCommand();

macroCommand.add(openWechat); // 宏命令中添加子命令
macroCommand.add(openChrome); // 宏命令中添加子命令
macroCommand.add(openEmail);  // 宏命令中添加子命令

macroCommand.execute();       // 执行宏命令
/* 输出：
打开微信
打开Chrome
打开Email
*/
```

### 傻瓜命令与智能命令
    
    傻瓜命令：命令对象需要接收者来执行客户的请求。智能命令：命令对象直接实
    现请求，不需要接收者，“聪明”的命令对象。

“傻瓜命令” 与 “智能命令” 的区别在于是否有 “接收者” 对象。

```js
// openWechat 是智能命令对象，并没有传入 receiver 接收对象
const openWechat = {
  execute: () => {  // 命令对象直接处理请求
    console.log('打开微信');
  }
};
```
没有 “接收者” 的智能命令与策略模式很类似。代码实现类似，区别在于实现目标不同。

1. 策略模式中实现的目标是一致的，只是实现算法不同（如目标：根据KPI计算奖金)；
2. 智能命令的解决问题更广，目标更具散发性。(如目标：计算奖金/计算出勤率等)。