## 代码演示

### 基础版

```tsx
/**
 * title: 基础用法
 * desc: 只需要传入一个list数组即可。
 */
import React from 'react';
import { Captions } from 'badger-ui';

export default () => {
	const list = [
		'那一刻，我升起风马不为乞福，只为守候你的到来',
		'那一日，垒起玛尼堆不为修德，只为投下心湖的石子',
		'那一夜，我听了一宿梵唱不为参悟，只为寻你的一丝气息；',
		'那一月，我摇动所有的经筒不为超度，只为触摸你的指尖；',
		'那一年，磕长头匍匐在山路不为觐见，只为贴着你的温暖；',
		'那一世，转山转水转佛塔啊不为修来生，只为途中与你相见；',
		'那一瞬，我飞升成仙，不为长生，只为佑你平安喜乐。',
	];
	return <Captions list={list} />;
};
```

### 插槽版

```tsx
/**
 * title: 插槽用法
 * desc: 不传入list数组，只要需要滚动的文字用组件包裹即可，可以做新闻的字幕。
 */
import React from 'react';
import { Captions } from 'badger-ui';

export default () => {
	const str =
		'那一刻，我升起风马不为乞福，只为守候你的到来；那一日，垒起玛尼堆不为修德，只为投下心湖的石子；那一夜，我听了一宿梵唱不为参悟，只为寻你的一丝气息；那一月，我摇动所有的经筒不为超度，只为触摸你的指尖；那一年，磕长头匍匐在山路不为觐见，只为贴着你的温暖；那一世，转山转水转佛塔啊不为修来生，只为途中与你相见；那一瞬，我飞升成仙，不为长生，只为佑你平安喜乐。';
	return <Captions>{str}</Captions>;
};
```

## API

通过设置不同的属性可以实现 Captions 为不同的样式滚动字幕的属性说明如下：

| 属性         | 说明                   | 类型     | 默认值         | 可选值 | 是否必须 | 备注 |
| :----------- | ---------------------- | :------- | :------------- | :----- | :------- | :--- |
| list         | 滚动字幕文字列表       | Array    | []             | 无     | 是       |      |
| speed        | 字幕滚动的速度         | Number   | 2              | 无     | 否       |      |
| color        | 字幕的颜色             | String   | #1a88e7        | 无     | 否       |      |
| textStyle    | 字幕的样式             | Object   | {}             | 无     | 否       |      |
| isStop       | 鼠标放到字幕上是否停止 | Boolean  | false          | true   | 否       |      |
| onMouseOver  | 鼠标移入字幕触发       | Function | (index)=> void | -      | -        |      |
| onMouseLeave | 鼠标移出字幕触发       | Function | (index)=> void | -      | -        |      |
| onCilck      | 点击字幕触发           | Function | (index)=> void | -      | -        |      |

## 源码

```ts
import React, { ReactNode, useState, useRef, useEffect } from 'react';

let requestId: any = null;

interface props {
	list?: Array<String>;
	speed?: number;
	color?: string;
	textStyle: Object;
	isStop?: Boolean;
	onMouseLeave: (index: number) => void;
	onMouseOver: (index: number) => void;
	onClick: (index: number) => void;
	children?: ReactNode;
}

export default ({
	list = [],
	speed = 2,
	color = '#1a88e7',
	textStyle = {},
	isStop = true,
	onMouseLeave,
	onMouseOver,
	onClick,
	children,
}: props) => {
	const [key, setKey] = useState<number>(0);
	const containerRef = useRef<any>(null);
	const textRef = useRef<any>(null);

	useEffect(() => {
		let container = containerRef?.current?.clientWidth;
		textRef.current.style.left = container + 'px';
		onAnimation();
		return () => {
			cancelAnimationFrame(requestId);
		};
	}, []);

	const onAnimation: any = (): void => {
		let textWidth = textRef.current?.clientWidth; // 文字宽度
		let textLeft = parseInt(textRef.current?.style?.left, 10); // 相对父元素偏移距离
		if (textLeft > -textWidth) {
			if (textRef?.current?.style) {
				textRef.current.style.left = textLeft - speed + 'px';
			}
		} else {
			let nextIndex = key !== list.length - 1 ? key + 1 : 0;
			setKey(nextIndex);
			if (textRef?.current?.style) {
				textRef.current.style.left =
					containerRef?.current?.clientWidth + 'px';
			}
			textWidth = textRef?.current?.clientWidth;
		}
		requestId = requestAnimationFrame(onAnimation);
	};

	const onTextMouseOver: any = (index: number): void => {
		if (isStop) {
			cancelAnimationFrame(requestId);
		}
		onMouseOver && onMouseOver(index);
	};
	const onTextMouseLeave: any = (index: number): void => {
		if (isStop) {
			onAnimation();
		}
		onMouseLeave && onMouseLeave(index);
	};

	const onTextClick = (index: number) => {
		onClick && onClick(index);
	};
	return (
		<>
			<div
				ref={containerRef}
				style={{
					position: 'relative',
					width: '100%',
					margin: '0 auto',
					padding: '0 10px',
					overflow: 'hidden',
					fontSize: '16px',
				}}
			>
				<span
					ref={textRef}
					style={{
						position: 'relative',
						display: 'inline-block',
						whiteSpace: 'nowrap',
						cursor: 'pointer',
						color: color,
						...textStyle,
					}}
					onClick={() => onTextClick(key)}
					onMouseOver={() => onTextMouseOver(key)}
					onMouseLeave={() => onTextMouseLeave(key)}
				>
					{list.length ? list[key] : children}
				</span>
			</div>
		</>
	);
};
```

更多问题请联系： <br />
<img src="http://leexiaop.github.io/static/ibadgers/wechat.jpeg" width="260" />
