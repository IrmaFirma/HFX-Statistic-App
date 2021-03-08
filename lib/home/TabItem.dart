import 'package:flutter/material.dart';

enum TabItem {records, entries, account}

class TabItemData{
  final String label;
  final IconData icon;

  const TabItemData({this.label, this.icon});


  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.records: TabItemData(label: 'Records', icon: Icons.work),
    TabItem.entries: TabItemData(label: 'Entries', icon: Icons.view_comfy_rounded),
    TabItem.account: TabItemData(label: 'Account', icon: Icons.person),
  };
}