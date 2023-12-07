中介者模式: 对象和对象之间借助第三方中介者进行通信。

## 场景 demo 
一场测试结束后, 公布结果: 告知解答出题目的人挑战成功, 否则挑战失败。
```js
const player = function(name) {
      this.name = name
      playerMiddle.add(name)
    }
    player.prototype.win = function() {
      playerMiddle.win(this.name)
    }
    player.prototype.lose = function(){
      playerMiddle.lose(this.name)
    }
    const playerMiddle =(function(){ //将就用下这个demo, 这个函数充当中介者
      const players =[]
      const winArr = []
      const loseArr = []
      return {
        add: function(name) {
          players.push(name)
        },
        win: function(name){
          winArr.push(name)
          if(winArr.length + loseArr.length === players.length){
            this.show()
          }
        },
        lose: function(name){
          loseArr.push(name)
          if(winArr.length + loseArr.length === players.length){
            this.show()
          }
        },
        show: function(){
          for(let winner of winArr){
            console.log(winner+'挑戰成功;')
          }
          for(let loser of loseArr){
            console.log(loser+'挑战失败;')
          }
        }
      }
    }())
    const a = new player('A选手')
    const b = new player('B选手')
    const c = new player('C选手')
    a.win()
    b.lose()
    c.win()
    // A 选手挑战成功;
// B 选手挑战成功;
// C 选手挑战失败;
```
在这段代码中 A、B、C 之间没有直接发生关系, 而是通过另外的 playerMiddle 对象建立链接, 姑且将之当成是中介者模式了。