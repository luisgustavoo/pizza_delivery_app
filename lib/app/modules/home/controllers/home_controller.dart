import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier{

  TabController tabController;
  GlobalKey bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();


  void changePage(int page){
    tabController.index = page;
    final CurvedNavigationBarState state = bottomNavigationKey.currentState as CurvedNavigationBarState;
    state.setPage(page);
  }


}