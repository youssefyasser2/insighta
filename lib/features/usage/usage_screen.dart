import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/navigation/routes.dart';

// BarVal Class
class BarVal {
  final int x;
  final double y;

  BarVal({required this.x, required this.y});
}

// BarData Class
class BarData {
  final double instaUse;
  final double faceUse;
  final double linkedInUse;
  final double snapchatUse;
  final double googleUse;
  final double twitUse;

  BarData({
    required this.instaUse,
    required this.faceUse,
    required this.linkedInUse,
    required this.snapchatUse,
    required this.googleUse,
    required this.twitUse,
  });

  List<BarVal> get barDataList => [
    BarVal(x: 0, y: instaUse),
    BarVal(x: 1, y: faceUse),
    BarVal(x: 2, y: linkedInUse),
    BarVal(x: 3, y: snapchatUse),
    BarVal(x: 4, y: googleUse),
    BarVal(x: 5, y: twitUse),
  ];
}

// SocialUsageBarChart
class SocialUsageBarChart extends StatelessWidget {
  final List<double> socialUsage;

  const SocialUsageBarChart({super.key, required this.socialUsage});

  @override
  Widget build(BuildContext context) {
    if (socialUsage.length < 6) {
      return const Center(child: Text("Data not available"));
    }

    BarData myBarData = BarData(
      instaUse: socialUsage[0],
      faceUse: socialUsage[1],
      linkedInUse: socialUsage[2],
      snapchatUse: socialUsage[3],
      googleUse: socialUsage[4],
      twitUse: socialUsage[5],
    );

    return SizedBox(
      width: 340.w,
      height: 200.h, // Increased height from 150.h to 200.h
      child: Card(
        color: const Color(0xFFF5F5F5),
        child: BarChart(
          BarChartData(
            barGroups:
                myBarData.barDataList
                    .map(
                      (data) => BarChartGroupData(
                        x: data.x,
                        barRods: [
                          BarChartRodData(
                            toY: data.y,
                            width: 20.w,
                            color: const Color(0xFF2E2E2E),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ],
                      ),
                    )
                    .toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: getSocialIcon,
                  reservedSize: 40,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            maxY: 100,
          ),
        ),
      ),
    );
  }
}

// CustomCard Widget (Updated to be clickable with responsive layout)
class CustomCard extends StatelessWidget {
  final String assetName;
  final String platformName;
  final List<Color> pieChartColors;
  final VoidCallback onTap; // Callback for navigation

  const CustomCard({
    super.key,
    required this.assetName,
    required this.platformName,
    required this.pieChartColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffC8C3C3)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: const Color(0xFFF5F5F5),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: SizedBox(
            height: 220.h, // Fixed height to constrain the Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose, // Allow flexible sizing
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Use min to shrink-wrap
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: _safeSvg(assetName: assetName),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            platformName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Flexible(
                        child: Text(
                          '"Please remember to wear a headscarf when visiting the mosque as a sign of respect for Islamic traditions and the sacredness of the place. Wearing a headscarf reflects modesty and reverence in religious spaces and is part of the etiquette for entering mosques."',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose, // Allow flexible sizing
                  child: CustomPieChart(colors: pieChartColors),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SocialUsageCard (Using CustomCard)
class SocialUsageCard extends StatelessWidget {
  const SocialUsageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          assetName: 'assets/svgs/linkedin_logo.svg',
          platformName: 'LinkedIn',
          pieChartColors: [const Color(0xFF076372), Colors.black],
          onTap: () => context.go('/detail/linkedin'),
        ),
        CustomCard(
          assetName: 'assets/svgs/snapchat_logo.svg',
          platformName: 'Snapchat',
          pieChartColors: [const Color(0xFF076372), Colors.black],
          onTap: () => context.go('/detail/snapchat'),
        ),
        CustomCard(
          assetName: 'assets/svgs/facebook_logo.svg',
          platformName: 'Facebook',
          pieChartColors: [const Color(0xFF076372), Colors.black],
          onTap: () => context.go('/detail/facebook'),
        ),
        CustomCard(
          assetName: 'assets/svgs/instagram_logo.svg',
          platformName: 'Instagram',
          pieChartColors: [const Color(0xFF076372), Colors.black],
          onTap: () => context.go('/detail/instagram'),
        ),
        CustomCard(
          assetName: 'assets/svgs/google_logo.svg',
          platformName: 'Google',
          pieChartColors: [const Color(0xFF076372), Colors.black],
          onTap: () => context.go('/detail/google'),
        ),
        CustomCard(
          assetName: 'assets/svgs/twitter_logo.svg',
          platformName: 'Twitter',
          pieChartColors: [const Color(0xFF076372), Colors.black],
          onTap: () => context.go('/detail/twitter'),
        ),
      ],
    );
  }
}

// CustomPieChart
class CustomPieChart extends StatelessWidget {
  final List<Color> colors;

  const CustomPieChart({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      height: 80.h,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 0,
          sections: List.generate(
            colors.length,
            (index) => PieChartSectionData(
              color: colors[index],
              value: 50.0,
              radius: 40.r,
              showTitle: false,
            ),
          ),
        ),
      ),
    );
  }
}

// Build top axis social icons
Widget getSocialIcon(double value, TitleMeta meta) {
  const iconPaths = [
    'assets/svgs/instagram_logo.svg',
    'assets/svgs/facebook_logo.svg',
    'assets/svgs/linkedin_logo.svg',
    'assets/svgs/snapchat_logo.svg',
    'assets/svgs/google_logo.svg',
    'assets/svgs/twitter_logo.svg',
  ];

  String? assetPath;
  try {
    assetPath = iconPaths[value.toInt()];
  } catch (e) {
    return const SizedBox();
  }

  return Padding(
    padding: EdgeInsets.only(top: 8.h),
    child: SizedBox(
      width: 24.w,
      height: 24.h,
      child: _safeSvg(assetName: assetPath),
    ),
  );
}

// Safe SVG display utility
Widget _safeSvg({required String assetName}) {
  return SvgPicture.asset(
    assetName,
    fit: BoxFit.contain,
    placeholderBuilder: (context) => const Center(child: Icon(Icons.image)),
  );
}

// UsageScreen
class UsageScreen extends StatelessWidget {
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usage"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.home);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                SocialUsageBarChart(socialUsage: [60, 80, 40, 50, 30, 70]),
                const SocialUsageCard(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
