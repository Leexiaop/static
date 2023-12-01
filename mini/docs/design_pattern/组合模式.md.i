## 定义
组合模式：又叫 “部分整体” 模式，将对象组合成树形结构，以表示 “部分-整体” 的层次结构。通过对象的多态性表现，使得用户对单个对象和组合对象的使用具有一致性。

## 模式特点

1. 表示 “部分-整体” 的层次结构，生成 "树叶型" 结构；
2. 一致操作性，树叶对象对外接口保存一致（操作与数据结构一致）；
3. 自上而下的的请求流向，从树对象传递给叶对象；
4. 调用顶层对象，会自行遍历其下的叶对象执行。

## 代码实现

树对象和叶对象接口统一，树对象增加一个缓存数组，存储叶对象。执行树对象方法时，将请求传递给其下叶对象执行。

```js
// 树对象 - 文件目录
class CFolder {
    constructor(name) {
        this.name = name;
        this.files = [];
    }

    add(file) {
        this.files.push(file);
    }

    scan() {
        for (let file of this.files) {
            file.scan();
        }
    }
}

// 叶对象 - 文件
class CFile {
    constructor(name) {
        this.name = name;
    }

    add(file) {
        throw new Error('文件下面不能再添加文件');
    }

    scan() {
        console.log(`开始扫描文件：${this.name}`);
    }
}

let mediaFolder = new CFolder('娱乐');
let movieFolder = new CFolder('电影');
let musicFolder = new CFolder('音乐');

let file1 = new CFile('钢铁侠.mp4');
let file2 = new CFile('再谈记忆.mp3');
movieFolder.add(file1);
musicFolder.add(file2);
mediaFolder.add(movieFolder);
mediaFolder.add(musicFolder);
mediaFolder.scan();

/* 输出:
开始扫描文件：钢铁侠.mp4
开始扫描文件：再谈记忆.mp3
*/
```

CFolder 与 CFile 接口保持一致。执行 scan() 时，若发现是树对象，则继续遍历其下的叶对象，执行 scan()。

JavaScript 不同于其它静态编程语言，实现组合模式的难点是保持树对象与叶对象之间接口保持统一，可借助 TypeScript 定制接口规范，实现类型约束。

```js
// 定义接口规范
interface Compose {
    name: string,
    add(file: CFile): void,
    scan(): void
}

// 树对象 - 文件目录
class CFolder implements Compose {
    fileList = [];
    name: string;

    constructor(name: string) {
        this.name = name;
    }

    add(file: CFile) {
        this.fileList.push(file);
    }

    scan() {
        for (let file of this.fileList) {
            file.scan();
        }
    }
}

// 叶对象 - 文件
class CFile implements Compose {
    name: string;

    constructor(name: string) {
        this.name = name;
    }

    add(file: CFile) {
        throw new Error('文件下面不能再添加文件');
    }

    scan() {
        console.log(`开始扫描：${this.name}`)
    }
}

let mediaFolder = new CFolder('娱乐');
let movieFolder = new CFolder('电影');
let musicFolder = new CFolder('音乐');

let file1 = new CFile('钢铁侠.mp4');
let file2 = new CFile('再谈记忆.mp3');
movieFolder.add(file1);
musicFolder.add(file2);
mediaFolder.add(movieFolder);
mediaFolder.add(musicFolder);
mediaFolder.scan();

/* 输出:
开始扫描文件：钢铁侠.mp4
开始扫描文件：再谈记忆.mp3
*/
```

## 透明性的安全问题

组合模式的透明性，指的是树叶对象接口保持统一，外部调用时无需区分。但是这会带来一些问题，如上述文件目录的例子，文件（叶对象）下不可再添加文件，因此需在文件类的 add() 方法中抛出异常，以作提醒。

## 误区规避
1. 组合不是继承，树叶对象并不是父子对象
组合模式的树型结构是一种 HAS-A（聚合）的关系，而不是 IS-A 。树叶对象能够合作的关键，是它们对外保持统一接口，而不是叶对象继承树对象的属性方法，两者之间不是父子关系。

2. 叶对象操作保持一致性
叶对象除了与树对象接口一致外，操作也必须保持一致性。一片叶子只能生在一颗树上。调用顶层对象时，每个叶对象只能接收一次请求，一个叶对象不能从属多个树对象。

3. 叶对象实现冒泡传递
请求传递由树向叶传递，如果想逆转传递过程，需在叶对象中保留对树对象的引用，冒泡传递给树对象处理。

4. 不只是简单的子集遍历
调用对象的接口方法时，如果该对象是树对象，则会将请求传递给叶对象，由叶对象执行方法，以此类推。不同于迭代器模式，迭代器模式遍历并不会做请求传导。

## 应用场景
优化处理递归或分级数据结构（文件系统 - 目录文件管理）；
与其它设计模式联用，如与命令模式联用实现 “宏命令”。

## 优缺点

### 优点：

忽略组合对象和单个对象的差别，对外一致接口使用；
解耦调用者与复杂元素之间的联系，处理方式变得简单。


### 缺点

树叶对象接口一致，无法区分，只有在运行时方可辨别；
包裹对象创建太多，额外增加内存负担。
