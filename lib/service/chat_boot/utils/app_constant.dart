import 'dart:math';

import 'package:flutter/material.dart';

class AppConstant {
  static final List<Map<String, dynamic>> defaultQues = [
    {
      "title": "📌 الأكثر شيوعًا",
      "question": [
        {
          "icon": Icons.ac_unit,
          "color": Colors.primaries[Random().nextInt(Colors.primaries.length)],
          "ques": "ما هي أفضل أنواع فلاتر الزيت؟"
        },
        {
          "icon": Icons.emoji_emotions_rounded,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "كيف أختار البواجي المناسبة لسيارتي؟"
        },
        {
          "icon": Icons.computer,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "متى يجب تغيير تيل الفرامل؟"
        },
        {
          "icon": Icons.cloud,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "ما الفرق بين قطع الغيار الأصلية والتجارية؟"
        },
        {
          "icon": Icons.label,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "هل القطع المتوافقة تؤثر على أداء السيارة؟"
        },
        {
          "icon": Icons.games_sharp,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "كيف أزيد من كفاءة محرك السيارة؟"
        },
        {
          "icon": Icons.terrain,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "كيف أفرق بين القطع الأصلية والمقلدة؟"
        },
        {
          "icon": Icons.nature_outlined,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "هل كل السيارات تقبل قطع غيار متوافقة؟"
        }
      ]
    },
    {
      "title": "🔥 الأسئلة الرائجة",
      "question": [
        {
          "icon": Icons.question_mark,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "ما هي علامات تلف طرمبة البنزين؟"
        },
        {
          "icon": Icons.swap_horizontal_circle_outlined,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "متى أغير بطارية السيارة؟"
        },
        {
          "icon": Icons.equalizer_rounded,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "ما أسباب ضعف تكييف السيارة؟"
        },
      ]
    },
    {
      "title": "🛠️ صيانة السيارة",
      "question": [
        {
          "icon": Icons.trending_up_rounded,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "ما أفضل نصائح لصيانة دورية للسيارة؟"
        },
        {
          "icon": Icons.align_horizontal_center_outlined,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "ما أفضل طريقة للتأكد من جودة قطع الغيار؟"
        },
        {
          "icon": Icons.video_collection_outlined,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "هل شراء قطع الغيار من الإنترنت آمن؟"
        },
        {
          "icon": Icons.monetization_on_outlined,
          "color":
              Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
          "ques": "هل يجب تغيير كل القطع التالفة بقطع أصلية؟"
        },
      ]
    }
  ];
}
