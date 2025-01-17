import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hungry/views/utils/AppColor.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  int selectedIndex;
  Function onItemTapped;
  CustomBottomNavigationBar({required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 60, right: 60, bottom: 20),
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(0.9),
            currentIndex: widget.selectedIndex,
            onTap: widget.onItemTapped as void Function(int)?,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              (widget.selectedIndex == 0)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/home-filled.svg', color: Color.fromARGB(255, 7, 77, 50)), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/home.svg', color: Colors.grey[600]), label: ''),
              (widget.selectedIndex == 1)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/camera-filled.svg', color: Color.fromARGB(255, 7, 77, 50), height: 28, width: 26), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/camera.svg', color: Colors.grey[600], height: 28, width: 26), label: ''),
              (widget.selectedIndex == 2)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/profile-filled.svg', color: Color.fromARGB(255, 7, 77, 50)), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/profile.svg', color: Colors.grey[600]), label: ''),
            ],
          ),
        ),
      ),
    );
  }
}
