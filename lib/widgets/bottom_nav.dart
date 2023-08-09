import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/page_provider.dart';
import 'package:mathsaide/widgets/nav_item.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      // margin: pa1,
      // padding: pa1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        // borderRadius: BorderRadius.circular(10),
      ),
      child: NavigationBar(
        // backgroundColor: cPri.withOpacity(0.5),
        surfaceTintColor: bgColDark,
        elevation: 3,
        selectedIndex: context.watch<PageProvider>().pageIndex,
        height: 50.w,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          SizedBox(
            height: 50.w,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 0;
                  Provider.of<PageProvider>(context, listen: false).setPage(0);
                });
              },
              child: pageIndex == 0
                  ? const NavItem(
                      label: "Learn",
                      icon: Icons.school,
                    )
                  : Icon(
                      Icons.school_outlined,
                      color: txtCol,
                      size: 24.w,
                    ),
            ),
          ),
          SizedBox(
            height: 50.w,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 1;
                  Provider.of<PageProvider>(context, listen: false).setPage(1);
                });
              },
              child: pageIndex == 1
                  ? const NavItem(
                      label: "Practice",
                      icon: Icons.menu_book,
                    )
                  : Icon(
                      Icons.menu_book_outlined,
                      color: txtCol,
                      size: 24.w,
                    ),
            ),
          ),
          SizedBox(
            height: 50.w,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 2;
                  Provider.of<PageProvider>(context, listen: false).setPage(2);
                });
              },
              child: pageIndex == 2
                  ? const NavItem(
                      label: "Quiz", icon: Icons.format_list_numbered)
                  : Icon(
                      Icons.format_list_numbered_outlined,
                      color: txtCol,
                      size: 24.w,
                    ),
            ),
          ),
          SizedBox(
            height: 50.w,
            // width: size.height * 0.06,
            child: InkWell(
              // iconSize: 16,
              onTap: () {
                setState(() {
                  pageIndex = 3;
                  Provider.of<PageProvider>(context, listen: false).setPage(3);
                });
              },
              child: pageIndex == 3
                  ? const NavItem(
                      label: "Settings",
                      icon: Icons.settings,
                    )
                  : Icon(
                      Icons.settings_outlined,
                      color: txtCol,
                      size: 24.w,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
