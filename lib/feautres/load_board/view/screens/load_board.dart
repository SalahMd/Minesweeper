import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/feautres/home/view/widgets/top_bar.dart';
import 'package:untitled/feautres/load_board/view/widgets/load_board_widget.dart';

class LoadBoard extends StatelessWidget {
  const LoadBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBar(title: "Load board"),
            SizedBox(
              height: 20.h,
            ),
            ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return LoadBoardWidget(
                    boardName: 'Saved board',
                    date: '2023/12/11',
                    onLoad: () {},
                    onRemove: () {},
                    id: index,
                  );
                })
          ],
        ),
      ),
    );
  }
}
