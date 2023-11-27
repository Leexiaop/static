## 概念
代理模式是为一个对象提供一个代用品或占位符，以便控制对它的访问。

## 场景
比如，明星都有经纪人作为代理。如果想请明星来办一场商业演出，只能联系他的经纪人。经纪人会把商业演出的细节和报酬都谈好之后，再把合同交给明星签。

## 分类


### 保护代理

于控制不同权限的对象对目标对象的访问，如上面明星经纪人的例子.

### 虚拟代理

把一些开销很大的对象，延迟到真正需要它的时候才去创建。
如短时间内发起很多个http请求，我们可以用虚拟代理实现一定时间内的请求统一发送

## 优缺点

### 优点

+ 1. 可以保护对象
+ 2. 优化性能，减少开销很大的对象
+ 3. 缓存结果

## 案例

### 加载一张图片

```js
  var myImage = (function () {
    var imgNode = document.createElement('img');
    document.body.appendChild(imgNode);
    return {
      setSrc: function (src) {
        imgNode.src = src;
      }
    }
  })();
  myImage.setSrc('https://xxxxxxx.com');
```