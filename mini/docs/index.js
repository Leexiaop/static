const fs = require('fs');
const path = require('path');
const arr = [];
let timer = null;
const fileDisplay = (url, cb) => {
    const filePath = path.resolve(url);
    fs.readdir(filePath, (err, files) => {
        if (err) return console.error('Error:(spec)', err)
        files.forEach((filename) => {
            const filedir = path.join(filePath, filename);
            fs.stat(filedir, (eror, stats) => {
                if (eror) return console.error('Error:(spec)', err);
                // 是否是文件
                const isFile = stats.isFile();
                // 是否是文件夹
                const isDir = stats.isDirectory();
                if (isFile) {
                    console.log(filedir)
                    let str = filedir.replace(__dirname, '').replace(/\\/img, '/')
                    let l = str.lastIndexOf('/') + 1
                    let r = str.indexOf('.')
                    arr.push(str.slice(l, r))
                    if (timer) clearTimeout(timer)
                    timer = setTimeout(() => cb && cb(arr), 200)
                }
                if (isDir) fileDisplay(filedir, cb);
            })
        });
    });
}
// 测试代码
fileDisplay('./jscoding', (arr) => {
    console.log(arr)
})
module.exports = fileDisplay;
