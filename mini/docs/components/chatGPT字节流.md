随着chatGPT的兴起，我们在输入一个问题后，chatGPT给出他的答案，而chatGPT的文字流样式也备受大家的喜欢，那么是如何实现的呢？
这里提供一种利用http实现的方法：

```js
const url = 'http:localhost:9999/chat';

async function getRespone (content) {
    const resp = await fetch(url, {
        metod: 'POST',
        headers: {
            'Content-type': 'application/json'
        },
        body: JSON.stringfy({content})
    })
    const data = await resp.text()
    console.log(data)
}
```
这是我们常规的一个请求，第一次await，要等到服务器的响应头到达客户端，而第二次awiat，就是等待响应体能到达客户端，所以这一步也是最为耗时的。也就是服务器要把所有的信息都返回后才会能打印出data.`但是此时，我们并不想等待全部响应完成再去做操作，而是，服务器给我们返回多少我们接收多少，将返回每一个部分展示在页面上，这就是流式读取。`所以我们要改造第二个await.

在resp的body中有一个方法叫getReader.我们调用这个方法就可以获取到对应的文本。在需要read方法读出来即可。

```js
const url = 'http:localhost:9999/chat';

async function getRespone (content) {
    const resp = await fetch(url, {
        metod: 'POST',
        headers: {
            'Content-type': 'application/json'
        },
        body: JSON.stringfy({content})
    })
    const reader = resp.body.getReader()  //  获取到返回的内容
    const decoder = new TextDecoder()
    while(true) {
        const { done, value } = await reader.read() //  这里是读出来了第一个流，所以我们需要通过解码器来循环解出文字
        if (done) {
            break
        }
        const text = decoder.decode(value)
        console.log(text)
    }
```
所以,如果文本比较多的时候，这也是一个优化的方案。