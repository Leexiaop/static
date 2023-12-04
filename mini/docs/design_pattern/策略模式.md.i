什么是策略模式，官方定义是：定义一些列算法，把他们封装起来，并且可以相互替换。就是把看似毫无联系的代码提取封装、复用，使之更容易被理解和拓展。常见的用于一次if判断、switch枚举、数据字典等流程判断语句中。

## 使用策略模式计算等级

在游戏中，我们每玩完一局游戏都有对用户进行等级评价，比如S级4倍经验，A级3倍经验，B级2倍经验，其他1倍经验，用函数来表达如下：

```js
    function getExperience(level, experience){
      if(level == 'S'){
        return 4*experience
      }
      if(level == 'A'){
        return 3*experience
      }
      if(level == 'B'){
        return 2*experience
      }
      return experience
    }

```
可知getExperience函数各种if条件判断，复用性差，我们根据策略模式封装复用的思想，进行改写。
```js
// 改为策略模式 分成两个函数来写
    const strategy = {
      'S' : function(experience){
        return 4*experience
      },
      'A' : function(experience){
        return 3*experience
      },
      'B' : function(experience){
        return 2*experience
      }
    }
    // getExperience可以复用
    function getExperience(strategy, level, experience){
      return (level in strategy) ? strategy[level](experience) : experience
    }
    var s = getExperience(strategy, 'S', 100)
    var a = getExperience(strategy, 'A', 100)
    console.log(s, a) // 400 300
```
分为两个函数之后，strategy对象解耦，拓展性强。在vue数据驱动视图更新的更新器updater使用，就使用了策略模式。想要进一步了解vue底层原理，可以参考可以参考github上的一篇文章 ☛ MVVM实现;

```js
// 指令处理集合
var compileUtil = {
    // v-text更新视图原理
    text: function(node, vm, exp) {
        this.bind(node, vm, exp, 'text');
    },
    // v-html更新视图原理
    html: function(node, vm, exp) {
        this.bind(node, vm, exp, 'html');
    },
    // v-class绑定原理
    class: function(node, vm, exp) {
        this.bind(node, vm, exp, 'class');
    },
    bind: function(node, vm, exp, dir) {
        // 不同指令触发视图更新
        var updaterFn = updater[dir + 'Updater'];
        updaterFn && updaterFn(node, this._getVMVal(vm, exp));
        new Watcher(vm, exp, function(value, oldValue) {
            updaterFn && updaterFn(node, value, oldValue);
        });
    }
    ......
}
```
## 使用策略模式验证表单
常见表单验证用if、else流程语句判断用户输入数据是否符合验证规则，而在Elementui中，基于async-validator库，只需要通过rule属性传入约定的验证规则，即可校验。方便快捷，可复用。现在我们根据策略模式仿写一个校验方式。
```html
  // 我们写一个form表单
    <form action="/" class="form">
      <input type="text" name="username">
      <input type="password" name="password"> 
      <button>submit</button>
    </form>
    <div id="tip"></div>
```
+ 首先定义校验规则
```js
    const strategies = {
      // 非空
      noEmpty: function(value, errMsg){
        if(value === ''){
          return errMsg
        }
      },
      // 最小长度
      minLength: function(value, length, errMsg){
        if(!value || value.length < length){
          return errMsg
        }
      },
      // 最大长度
      maxLength: function(value, length, errMsg){
        if(value.length > length){
          return errMsg
        }
      }
    }
```
+ 接着设置验证器
```js
// 创建验证器
    var Validator = function(strategies){
      this.strategies = strategies
      this.cache = [] // 存储校验规则
    }
    // 添加校验规则
    Validator.prototype.add = function(dom, rules){
      rules.forEach(item => {
        this.cache.push(() => {
          let value = dom.value
          let arr = item.rule.split(':')
          let name = arr.shift()
          let params = [value, ...arr, item.errMsg]
          // apply保证上下文一致
          return this.strategies[name].apply(dom, params)
        })
      })
    }
    // 校验结果
    Validator.prototype.validate = function(dom, rules, errMsg){
      // 遍历cache里面的校验函数
      for(let i = 0, validateFun; validateFun = this.cache[i++];){
        const message = validateFun()
        // 返回报错信息，终止验证并抛出异常
        if(message) return message
      }
    }
```
+ 最后进行校验
```js
 var form = document.querySelector("form")
    // 提交表单
    form.onsubmit = function(event){
      event.preventDefault() 
      // 判断验证结果
      const message = validate()
      const tip = document.getElementById('tip')
      if(message){
        tip.innerHTML = message
        tip.style.color = 'red'
      }else{
        tip.innerHTML = '验证通过！'
        tip.style.color = 'green'
      }
    }
    // 校验函数
    function validate(){
      // 实例验证器
      const validator = new Validator(strategies)
      // 添加验证规则
      validator.add(form.username, [
        {
          rule: 'noEmpty',
          errMsg: '用户名不能为空!'
        },
        {
          rule: 'minLength:3',
          errMsg: '用户名长度大于3!'
        }
      ])
      validator.add(form.password, [
        {
          rule: 'minLength:6',
          errMsg: '密码长度大于6!'
        },
        {
          rule: 'maxLength:10',
          errMsg: '密码最大长度为10!'
        }
      ])
      // 进行校验，并返回结果
      return validator.validate()
    }
```
如上所示，我们只要添加strategies对象的属性，就能自定义自己的验证规则，并且可以复用，大大方便了日常开发！