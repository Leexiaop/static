## 解释器模式

给定一个语言, 定义它的文法的一种表示，并定义一个解释器, 该解释器使用该表示来解释语言中的句子。

```js
class Context {
    constructor() {
      this._list = []; // 存放 终结符表达式
      this._sum = 0; // 存放 非终结符表达式(运算结果)
    }
  
    get sum() {
      return this._sum;
    }
    set sum(newValue) {
      this._sum = newValue;
    }
    add(expression) {
      this._list.push(expression);
    }
    get list() {
      return [...this._list];
    }
  }
  
  class PlusExpression {
    interpret(context) {
      if (!(context instanceof Context)) {
        throw new Error("TypeError");
      }
      context.sum = ++context.sum;
    }
  }
  class MinusExpression {
    interpret(context) {
      if (!(context instanceof Context)) {
        throw new Error("TypeError");
      }
      context.sum = --context.sum;
    }
  }
  
  /** 以下是测试代码 **/
  const context = new Context();
  
  // 依次添加: 加法 | 加法 | 减法 表达式
  context.add(new PlusExpression());
  context.add(new PlusExpression());
  context.add(new MinusExpression());
  
  // 依次执行: 加法 | 加法 | 减法 表达式
  context.list.forEach(expression => expression.interpret(context));
  console.log(context.sum);
```

## 优点
1. 易于改变和扩展文法。
2. 由于在解释器模式中使用类来表示语言的文法规则，因此可以通过继承等机制来改变或扩展文法

## 缺点
1. 执行效率较低，在解释器模式中使用了大量的循环和递归调用，因此在解释较为复杂的句子时其速度慢
2. 对于复杂的文法比较难维护