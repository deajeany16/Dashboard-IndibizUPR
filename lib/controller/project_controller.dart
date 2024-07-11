import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webui/controller/my_controller.dart';

class ChartSampleData {
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  final dynamic x;
  final num? y;
  final dynamic xValue;
  final num? yValue;
  final num? secondSeriesYValue;
  final num? thirdSeriesYValue;
  final Color? pointColor;
  final num? size;
  final String? text;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
  final num? volume;
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}

class ProjectController extends MyController {
  int selectTime = 1;
  String selectedDailyTask = "Today";
  String selectedTeamMember = "Active";

  void select(int select) {
    selectTime = select;
    update();
  }

  void onDailyTask(String time) {
    selectedDailyTask = time;
    update();
  }

  void onTeamMember(String time) {
    selectedTeamMember = time;
    update();
  }

  final List<ChartSampleData> doughnutChartData = <ChartSampleData>[
    ChartSampleData(x: 'Pending', y: 55, text: '55%', pointColor: Colors.blue),
    ChartSampleData(x: 'Done', y: 31, text: '31%', pointColor: Colors.green),
  ];

  final List<ChartSampleData> columnChart = <ChartSampleData>[
    ChartSampleData(x: 2010, y: 32, yValue: 80),
    ChartSampleData(x: 2011, y: 44, yValue: 70),
    ChartSampleData(x: 2012, y: 40, yValue: 60),
    ChartSampleData(x: 2013, y: 50, yValue: 78),
    ChartSampleData(x: 2014, y: 10, yValue: 58),
    ChartSampleData(x: 2015, y: 20, yValue: 66),
    ChartSampleData(x: 2016, y: 30, yValue: 90),
  ];
  final List<ChartSampleData> radialChartData = <ChartSampleData>[
    ChartSampleData(
        x: 'UI/UX Design',
        y: 10,
        text: '100%',
        pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
    ChartSampleData(
        x: 'Illustration Design',
        y: 11,
        text: '100%',
        pointColor: const Color.fromRGBO(246, 114, 128, 1.0)),
    ChartSampleData(
        x: 'Web Development',
        y: 12,
        text: '100%',
        pointColor: const Color.fromRGBO(61, 205, 171, 1.0)),
    ChartSampleData(
        x: 'Product Design',
        y: 13,
        text: '100%',
        pointColor: const Color.fromRGBO(1, 174, 190, 1.0)),
  ];
  final TooltipBehavior radialTooltipBehavior =
      TooltipBehavior(enable: true, format: 'point.x : point.ym');

  Map dailyTask = {
    'taskList': [
      {
        'pageDesignName': 'Landing Page Design',
        'pageName': 'Create a new landing page (Saas Product)',
        'people': '5',
      },
      {
        'pageDesignName': 'Admin Dashboard',
        'pageName': 'Create a new Admin dashboard',
        'people': '2',
      },
      {
        'pageDesignName': 'Client Work',
        'pageName': 'Create a new Power Project (Sketch design)',
        'people': '2',
      },
      {
        'pageDesignName': 'UI/UX Design',
        'pageName': 'Create a new UI Kit in figma',
        'people': '3',
      },
    ],
  };
  Map teamMember = {
    'memberList': [
      {
        'name': 'Risa Pearson',
        'languageName': 'UI/UX Designer',
      },
      {
        'name': 'Margaret D. Evans',
        'languageName': 'PHP Developer',
      },
      {
        'name': 'Bryan J. Luelle',
        'languageName': 'Front end Developer',
      },
      {
        'name': 'Kathryn S. Collier',
        'languageName': 'UI/UX Designer',
      },
      {
        'name': 'Timothy Pauper',
        'languageName': 'Backend Developer',
      },
      {
        'name': 'Zara Raw',
        'languageName': 'Python Developer',
      },
    ]
  };
}
