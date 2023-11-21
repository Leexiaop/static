建造者模式将一个复杂对象的构建层与其表示层相互分离，同样的构建过程可采用不同的表示。 工厂模式主要是为了创建对象实例或者类簇（抽象工厂），关心的是最终产出(创建)的是什么，而不关心创建的过程。而建造者模式关心的是创建这个对象的整个过程，甚至于创建对象的每一个细节。 以下以创建应聘者为例：应聘者有兴趣爱好，姓名和期望的职位等等.

```js
//创建一位人类
var Human = function (param) {
    //技能
    this.skill = param && param.skill || '保密';//如果存在param参数，并且param拥有skill属性，就用这个属性赋值给this的skill属性，否则将yoga默认值保密来设置
    this.hobby = param && param.hobby || '保密';
}
//类原型方法
Human.prototype = {
    getSkill : function () {
        return this.skill;
    },
    getHobby :function () {
        return this.hobby;
    }
}
```
应聘者有姓名和工作，先实例化其姓名类和工作类.
```js
//实例化姓名类
var Named = function (name) {
    var that = this;
    //构造器
    //构造函数解析姓名的姓和名
    (function (name, that) {
        that.wholeName = name;
        if(name.indexOf('') > -1){
            that.FirstName = name.slice(0,name.indexOf(' '));
            that.secondName = name.slice(name.indexOf(' '));
        }
    })(name,that);
}
//实例化职位类
var Work = function (work) {
    var that = this;
    //构造器
    //构造函数中通过传入的职位特征来设置相应职位以及描述
    (function (work,that) {
        switch(work){
            case 'code':that.work ='工程师';
                        that.workDescript ='每天沉醉于编程';
                        break;
            case 'UI':
            case 'UE':that.work = '设计师';
                        that.workDescript = '设计更似一种艺术';
                        break;
            case 'teach':that.work ='教师';
                         that.workDescript = '分享也是一种快乐';
                         break;
            default:that.work = work;
                    that.workDescript = '对不起，我们还不清楚您所选择职位的相关描述';
        }
    })(work,that);
}
//更换期望的职位
Work.prototype.changeWork = function (work) {
    this.work = work;
}
//添加对职位的描述
Work.prototype.changeDescript = function (sentence) {
    this.workDescript = sentence;
}
```
这样就创建了抽象出来的3个类：应聘者类，姓名解析类和期望职位类。可以通过对这三个类的组合调用，写一个建造者类来创建出一个完整的应聘对象。

```js
/**
 *应聘者建造类
 * 参数name:姓名（全名）
 * 参数work：期望职位
 */
var Person = function (name,work) {
    //创建应聘者缓存对象
    var _person = new Human();
    //创建应聘者姓名解析对象
    _person.name = new Named(name);
    _person.work = new Work(work);
    //将创建的应聘者对象返回
    return _person;
}
```
创建一位建造者缓存对象测试：

```js
//测试
var person = new Person('xiao ming','code');
console.log(person.skill);//保密
console.log(person.name.FirstName);//xiao
console.log(person.name.secondName);//ming
console.log(person.work.work);//工程师
console.log(person.work.workDescript);//每天沉醉于代码
person.work.changeDescript('更改描述！');
console.log(person.work.workDescript);//更改描述！
```
通过观察可以发现，建造者模式和工厂模式是有所不同的，建造者模式不仅可以得到创建的结果，而且参与了创建的具体过程，也干涉了创建的具体实现的细节。