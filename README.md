# carousel_3d

A new Flutter package.

## TransformerPageView简易的3D翻转效果

   Carousel3DWidget
   
##Installation
  carousel_3d:
##simple
```dart
import 'package:carousel_3d/carousel_3d.dart';
   
    ...
    
  Carousel3DWidget(autoPlay: false, //自动播放
         loop: true,//无限循环
         duration: 1000,//反循环效果时间
         viewportFraction: 0.6,//所占宽度比例
         scale: 0.7,//翻转放缩比例
         itemBuilder: (BuildContext context, int index) {
               return Image.asset(imgs[index],fit: BoxFit.cover,);
         },
         itemCount: imgs.length,)
```
  