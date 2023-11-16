## 什么是工厂模式?

工厂模式是用来创建对象的一种最常用的设计模式。我们不暴露创建对象的具体逻辑，而是将将逻辑封装在一个函数中，那么这个函数就可以被视为一个工厂。工厂模式根据抽象程度的不同可以分为：简单工厂，工厂方法和抽象工厂。

如果只接触过JavaScript这门语言的的人可能会对抽象这个词的概念有点模糊，因为JavaScript一直将abstract作为保留字而没有去实现它。如果不能很好的理解抽象的概念，那么就很难理解工厂模式中的三种方法的异同。所以，我们先以一个场景去简单的讲述一下抽象和工厂的概念。

## 简单工厂模式

简单工厂模式又叫静态工厂模式，由一个工厂对象决定创建某一种产品对象类的实例。主要用来创建同一类对象。

在实际的项目中，我们常常需要根据用户的权限来渲染不同的页面，高级权限的用户所拥有的页面有些是无法被低级权限的用户所查看。所以我们可以在不同权限等级用户的构造函数中，保存该用户能够看到的页面。在根据权限实例化用户。代码如下：
```js
let UserFactory = function (role) {
  function SuperAdmin() {
    this.name = "超级管理员",
    this.viewPage = ['首页', '通讯录', '发现页', '应用数据', '权限管理']
  }
  function Admin() {
    this.name = "管理员",
    this.viewPage = ['首页', '通讯录', '发现页', '应用数据']
  }
  function NormalUser() {
    this.name = '普通用户',
    this.viewPage = ['首页', '通讯录', '发现页']
  }
​
  switch (role) {
    case 'superAdmin':
      return new SuperAdmin();
      break;
    case 'admin':
      return new Admin();
      break;
    case 'user':
      return new NormalUser();
      break;
    default:
      throw new Error('参数错误, 可选参数:superAdmin、admin、user');
  }
}
​
//调用
let superAdmin = UserFactory('superAdmin');
let admin = UserFactory('admin') 
let normalUser = UserFactory('user')
```
UserFactory就是一个简单工厂，在该函数中有3个构造函数分别对应不同的权限的用户。当我们调用工厂函数时，只需要传递superAdmin, admin, user这三个可选参数中的一个获取对应的实例对象。你也许发现，我们的这三类用户的构造函数内部很相识，我们还可以对其进行优化。
```js
let UserFactory = function (role) {
  function User(opt) {
    this.name = opt.name;
    this.viewPage = opt.viewPage;
  }
​
  switch (role) {
    case 'superAdmin':
      return new User({ name: '超级管理员', viewPage: ['首页', '通讯录', '发现页', '应用数据', '权限管理'] });
      break;
    case 'admin':
      return new User({ name: '管理员', viewPage: ['首页', '通讯录', '发现页', '应用数据'] });
      break;
    case 'user':
      return new User({ name: '普通用户', viewPage: ['首页', '通讯录', '发现页'] });
      break;
    default:
      throw new Error('参数错误, 可选参数:superAdmin、admin、user')
  }
}
​
//调用
let superAdmin = UserFactory('superAdmin');
let admin = UserFactory('admin') 
let normalUser = UserFactory('user')
```
简单工厂的优点在于，你只需要一个正确的参数，就可以获取到你所需要的对象，而无需知道其创建的具体细节。但是在函数内包含了所有对象的创建逻辑（构造函数）和判断逻辑的代码，每增加新的构造函数还需要修改判断逻辑代码。当我们的对象不是上面的3个而是30个或更多时，这个函数会成为一个庞大的超级函数，便得难以维护。所以，简单工厂只能作用于`创建的对象数量较少，对象的创建逻辑不复杂时使用。`

## 工厂方法模式

工厂方法模式的本意是将实际创建对象的工作推迟到子类中，这样核心类就变成了抽象类。但是在JavaScript中很难像传统面向对象那样去实现创建抽象类。所以在JavaScript中我们只需要参考它的核心思想即可。我们可以将工厂方法看作是一个实例化对象的工厂类。

在简单工厂模式中，我们每添加一个构造函数需要修改两处代码。现在我们使用工厂方法模式改造上面的代码，刚才提到，工厂方法我们只把它看作是一个实例化对象的工厂，它只做实例化对象这一件事情！ 我们采用安全模式创建对象。
```js
//安全模式创建的工厂方法函数
let UserFactory = function(role) {
  if(this instanceof UserFactory) {
    var s = new this[role]();
    return s;
  } else {
    return new UserFactory(role);
  }
}
​
//工厂方法函数的原型中设置所有对象的构造函数
UserFactory.prototype = {
  SuperAdmin: function() {
    this.name = "超级管理员",
    this.viewPage = ['首页', '通讯录', '发现页', '应用数据', '权限管理']
  },
  Admin: function() {
    this.name = "管理员",
    this.viewPage = ['首页', '通讯录', '发现页', '应用数据']
  },
  NormalUser: function() {
    this.name = '普通用户',
    this.viewPage = ['首页', '通讯录', '发现页']
  }
}
​
//调用
let superAdmin = UserFactory('SuperAdmin');
let admin = UserFactory('Admin') 
let normalUser = UserFactory('NormalUser')
```
上面的这段代码就很好的解决了每添加一个构造函数就需要修改两处代码的问题，如果我们需要添加新的角色，只需要在UserFactory.prototype中添加。例如，我们需要添加一个VipUser:
```js
UserFactory.prototype = {
  //....
  VipUser: function() {
    this.name = '付费用户',    
    this.viewPage = ['首页', '通讯录', '发现页', 'VIP页']
  }
}
​
//调用
let vipUser = UserFactory('VipUser');
```
上面的这段代码中，使用到的安全模式可能很难一次就能理解。
```js
let UserFactory = function(role) {
  if(this instanceof UserFactory) {
    var s = new this[role]();
    return s;
  } else {
    return new UserFactory(role);
  }
}
```
因为我们将SuperAdmin、Admin、NormalUser等构造函数保存到了UserFactory.prototype中，也就意味着我们必须实例化UserFactory函数才能够进行以上对象的实例化。如下面代码所示:
```js
let UserFactory = function() {}
​
UserFactory.prototype = {
 //...
}
​
//调用
let factory = new UserFactory();
let superAdmin = new factory.SuperAdmin();
```
在上面的调用函数的过程中, 一旦我们在任何阶段忘记使用new, 那么就无法正确获取到superAdmin这个对象。但是一旦使用安全模式去进行实例化，就能很好解决上面的问题。

## ES6中的工厂模式
ES6中给我们提供了class新语法，虽然class本质上是一颗语法糖，并也没有改变JavaScript是使用原型继承的语言，但是确实让对象的创建和继承的过程变得更加的清晰和易读。下面我们使用ES6的新语法来重写上面的例子。

## ES6重写简单工厂模式
使用ES6重写简单工厂模式时，我们不再使用构造函数创建对象，而是使用class的新语法，并使用static关键字将简单工厂封装到User类的静态方法中:

```js
//User类
class User {
  //构造器
  constructor(opt) {
    this.name = opt.name;
    this.viewPage = opt.viewPage;
  }
​
  //静态方法
  static getInstance(role) {
    switch (role) {
      case 'superAdmin':
        return new User({ name: '超级管理员', viewPage: ['首页', '通讯录', '发现页', '应用数据', '权限管理'] });
        break;
      case 'admin':
        return new User({ name: '管理员', viewPage: ['首页', '通讯录', '发现页', '应用数据'] });
        break;
      case 'user':
        return new User({ name: '普通用户', viewPage: ['首页', '通讯录', '发现页'] });
        break;
      default:
        throw new Error('参数错误, 可选参数:superAdmin、admin、user')
    }
  }
}
​
//调用
let superAdmin = User.getInstance('superAdmin');
let admin = User.getInstance('admin');
let normalUser = User.getInstance('user');
```

## ES6重写工厂方法模式

在上文中我们提到，工厂方法模式的本意是将实际创建对象的工作推迟到子类中，这样核心类就变成了抽象类。但是JavaScript的abstract是一个保留字，并没有提供抽象类，所以之前我们只是借鉴了工厂方法模式的核心思想。

虽然ES6也没有实现abstract，但是我们可以使用new.target来模拟出抽象类。new.target指向直接被new执行的构造函数，我们对new.target进行判断，如果指向了该类则抛出错误来使得该类成为抽象类。下面我们来改造代码。

```js
class User {
  constructor(name = '', viewPage = []) {
    if(new.target === User) {
      throw new Error('抽象类不能实例化!');
    }
    this.name = name;
    this.viewPage = viewPage;
  }
}
​
class UserFactory extends User {
  constructor(name, viewPage) {
    super(name, viewPage)
  }
  create(role) {
    switch (role) {
      case 'superAdmin': 
        return new UserFactory( '超级管理员', ['首页', '通讯录', '发现页', '应用数据', '权限管理'] );
        break;
      case 'admin':
        return new UserFactory( '普通用户', ['首页', '通讯录', '发现页'] );
        break;
      case 'user':
        return new UserFactory( '普通用户', ['首页', '通讯录', '发现页'] );
        break;
      default:
        throw new Error('参数错误, 可选参数:superAdmin、admin、user')
    }
  }
}
​
let userFactory = new UserFactory();
let superAdmin = userFactory.create('superAdmin');
let admin = userFactory.create('admin');
let user = userFactory.create('user');
```

## ES6重写抽象工厂模式

抽象工厂模式并不直接生成实例， 而是用于对产品类簇的创建。我们同样使用new.target语法来模拟抽象类，并通过继承的方式创建出UserOfWechat, UserOfQq, UserOfWeibo这一系列子类类簇。使用getAbstractUserFactor来返回指定的类簇。

```js
class User {
  constructor(type) {
    if (new.target === User) {
      throw new Error('抽象类不能实例化!')
    }
    this.type = type;
  }
}

class UserOfWechat extends User {
  constructor(name) {
    super('wechat');
    this.name = name;
    this.viewPage = ['首页', '通讯录', '发现页']
  }
}

class UserOfQq extends User {
  constructor(name) {
    super('qq');
    this.name = name;
    this.viewPage = ['首页', '通讯录', '发现页']
  }
}

class UserOfWeibo extends User {
  constructor(name) {
    super('weibo');
    this.name = name;
    this.viewPage = ['首页', '通讯录', '发现页']
  }
}

function getAbstractUserFactory(type) {
  switch (type) {
    case 'wechat':
      return UserOfWechat;
      break;
    case 'qq':
      return UserOfQq;
      break;
    case 'weibo':
      return UserOfWeibo;
      break;
    default:
      throw new Error('参数错误, 可选参数:superAdmin、admin、user')
  }
}

let WechatUserClass = getAbstractUserFactory('wechat');
let QqUserClass = getAbstractUserFactory('qq');
let WeiboUserClass = getAbstractUserFactory('weibo');

let wechatUser = new WechatUserClass('微信小李');
let qqUser = new QqUserClass('QQ小李');
let weiboUser = new WeiboUserClass('微博小李');
```

## 工厂模式的项目实战应用

在实际的前端业务中，最常用的简单工厂模式。如果不是超大型的项目，是很难有机会使用到工厂方法模式和抽象工厂方法模式的。下面我介绍在Vue项目中实际使用到的简单工厂模式的应用。

在普通的vue + vue-router的项目中，我们通常将所有的路由写入到router/index.js这个文件中。下面的代码我相信vue的开发者会非常熟悉，总共有5个页面的路由：

```js
// index.js

import Vue from 'vue'
import Router from 'vue-router'
import Login from '../components/Login.vue'
import SuperAdmin from '../components/SuperAdmin.vue'
import NormalAdmin from '../components/Admin.vue'
import User from '../components/User.vue'
import NotFound404 from '../components/404.vue'

Vue.use(Router)

export default new Router({
  routes: [
    //重定向到登录页
    {
      path: '/',
      redirect: '/login'
    },
    //登陆页
    {
      path: '/login',
      name: 'Login',
      component: Login
    },
    //超级管理员页面
    {
      path: '/super-admin',
      name: 'SuperAdmin',
      component: SuperAdmin
    },
    //普通管理员页面
    {
      path: '/normal-admin',
      name: 'NormalAdmin',
      component: NormalAdmin
    },
    //普通用户页面
    {
      path: '/user',
      name: 'User',
      component: User
    },
    //404页面
    {
      path: '*',
      name: 'NotFound404',
      component: NotFound404
    }
  ]
})

```
当涉及权限管理页面的时候，通常需要在用户登陆根据权限开放固定的访问页面并进行相应权限的页面跳转。但是如果我们还是按照老办法将所有的路由写入到router/index.js这个文件中，那么低权限的用户如果知道高权限路由时，可以通过在浏览器上输入url跳转到高权限的页面。所以我们必须在登陆的时候根据权限使用vue-router提供的addRoutes方法给予用户相对应的路由权限。这个时候就可以使用简单工厂方法来改造上面的代码。

在router/index.js文件中，我们只提供/login这一个路由页面。
```js
//index.js

import Vue from 'vue'
import Router from 'vue-router'
import Login from '../components/Login.vue'

Vue.use(Router)

export default new Router({
  routes: [
    //重定向到登录页
    {
      path: '/',
      redirect: '/login'
    },
    //登陆页
    {
      path: '/login',
      name: 'Login',
      component: Login
    }
  ]
})
```
我们在router/文件夹下新建一个routerFactory.js文件，导出routerFactory简单工厂函数，用于根据用户权限提供路由权限，代码如下:
```js
//routerFactory.js

import SuperAdmin from '../components/SuperAdmin.vue'
import NormalAdmin from '../components/Admin.vue'
import User from '../components/User.vue'
import NotFound404 from '../components/404.vue'

let AllRoute = [
  //超级管理员页面
  {
    path: '/super-admin',
    name: 'SuperAdmin',
    component: SuperAdmin
  },
  //普通管理员页面
  {
    path: '/normal-admin',
    name: 'NormalAdmin',
    component: NormalAdmin
  },
  //普通用户页面
  {
    path: '/user',
    name: 'User',
    component: User
  },
  //404页面
  {
    path: '*',
    name: 'NotFound404',
    component: NotFound404
  }
]

let routerFactory = (role) => {
  switch (role) {
    case 'superAdmin':
      return {
        name: 'SuperAdmin',
        route: AllRoute
      };
      break;
    case 'normalAdmin':
      return {
        name: 'NormalAdmin',
        route: AllRoute.splice(1)
      }
      break;
    case 'user':
      return {
        name: 'User',
        route:  AllRoute.splice(2)
      }
      break;
    default: 
      throw new Error('参数错误! 可选参数: superAdmin, normalAdmin, user')
  }
}

export { routerFactory }
```
在登陆页导入该方法，请求登陆接口后根据权限添加路由:
```js
//Login.vue

import {routerFactory} from '../router/routerFactory.js'
export default {
  //... 
  methods: {
    userLogin() {
      //请求登陆接口, 获取用户权限, 根据权限调用this.getRoute方法
      //..
    },
    
    getRoute(role) {
      //根据权限调用routerFactory方法
      let routerObj = routerFactory(role);
      
      //给vue-router添加该权限所拥有的路由页面
      this.$router.addRoutes(routerObj.route);
      
      //跳转到相应页面
      this.$router.push({name: routerObj.name})
    }
  }
};
```

在实际项目中，因为使用this.$router.addRoutes方法添加的路由刷新后不能保存，所以会导致路由无法访问。通常的做法是本地加密保存用户信息，在刷新后获取本地权限并解密，根据权限重新添加路由。这里因为和工厂模式没有太大的关系就不再赘述。

## 总结

上面说到的工厂模式和上文的单例模式一样，都是属于创建型的设计模式。简单工厂模式又叫静态工厂方法，用来创建某一种产品对象的实例，用来创建单一对象；工厂方法模式是将创建实例推迟到子类中进行；抽象工厂模式是对类的工厂抽象用来创建产品类簇，不负责创建某一类产品的实例。在实际的业务中，需要根据实际的业务复杂度来选择合适的模式。对于非大型的前端应用来说，灵活使用简单工厂其实就能解决大部分问题。

## 什么时候会用工厂模式？

将new操作简单封装，遇到new的时候就应该考虑是否用工厂模式；

## jQuery工厂模式

jQuery的$(selector) jQuery中$('div')和new $('div')哪个好用，很显然直接$()最方便 ,这是因为$()已经是一个工厂方法了;

```js
class jQuery {
    constructor(selector) {
        super(selector)
    }
    //  ....
}
​
window.$ = function(selector) {
    return new jQuery(selector)
}
```

## React的createElement()

React.createElement()方法就是一个工厂方法;
```js
var profile = <div>
  <img src="avatar.png" className="profile"/>
  <h3>{[user.firstName, user.lastName].join('')}</h3>
</div>
var profile = React.createElement("div", null,
   React.createElement("img", {src:"avatar.png", className:"profile"}),
   React.createElement("h3", null, [user.firstName, user.lastName].join('')),  
)
```

## Vue的异步组件

通过promise的方式resolve出来一个组件.
```js
Vue.component("example", function(reslove, reject){
    setTimeout(()=>{
        reslove({
            template:'<div>i am async!</div>'
        })
    })
})
```