import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/controller/search_controller.dart';
import 'package:whatsapp/controller/tabController.dart';
import 'package:whatsapp/view/common/colors.dart';
import 'package:whatsapp/view/common/text.dart';
import 'package:whatsapp/view/home_screen/calls.dart';
import 'package:whatsapp/view/home_screen/chat_room/chats.dart';
import 'package:whatsapp/view/home_screen/setting_screen.dart';
import 'package:whatsapp/view/home_screen/status/status.dart';
import '../auth/mobile_screen.dart';
import 'chat_room/user_select.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  TabsController tabsController = Get.put(TabsController());
  List tab = [
    Ts(
      text: 'CHATS',
      color: AppColors.white,
      size: Get.height * 0.016,
    ),
    Ts(
      text: 'STATUS',
      color: AppColors.white,
      size: Get.height * 0.016,
    ),
    Ts(
      text: 'CALLS',
      color: AppColors.white,
      size: Get.height * 0.016,
    ),
  ];
  bool isFloat = true;
  var image;

  initState() {
    tabController =
        TabController(length: tab.length, initialIndex: 0, vsync: this);
    image = storage.read('userImage');
    print('USERIMAGE:- $image');
    tabController!.addListener(() {
      if (tabController!.index == 0) {
        isFloat = true;
      } else {
        isFloat = false;
      }
      setState(() {});
    });
    super.initState();
  }

  TextEditingController _search = TextEditingController();
  String searchText = '';
  SearchUserController searchController = Get.put(SearchUserController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: isFloat
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => UserSelectScreen());
              },
              child: Icon(Icons.message),
              backgroundColor: AppColors.mainColor,
            )
          : FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.camera),
              backgroundColor: AppColors.mainColor,
            ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, index) {
          return [
            Obx(
              () => SliverAppBar(
                elevation: 5,
                toolbarHeight: height * 0.03,
                pinned: true,
                backgroundColor: AppColors.mainColor,
                expandedHeight: searchController.isSearch.value == true
                    ? height * 0.07
                    : height * 0.12,
                flexibleSpace: searchController.isSearch.value == true
                    ? SafeArea(
                        child: AnimatedContainer(
                          color: Colors.white,
                          height: height * 0.07,
                          width: width,
                          curve: Curves.bounceInOut,
                          duration: Duration(seconds: 5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.005,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      searchController.isNotSearched();
                                      setState(() {
                                        searchText = '';
                                      });
                                      Get.back();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _search,
                                      onChanged: (value) {
                                        setState(() {
                                          searchText = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: width * 0.02),
                                        hintText: "Search....",
                                        hintStyle:
                                            TextStyle(fontSize: height * 0.022),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : FlexibleSpaceBar(
                        background: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.04, right: width * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Ts(
                                  text: 'WhatsApp',
                                  size: height * 0.025,
                                  color: AppColors.white,
                                ),
                                Spacer(),
                                IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    searchController.isSearched();
                                    setState(() {
                                      searchText = '';
                                      _search.clear();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: AppColors.white,
                                  ),
                                ),
                                PopupMenuButton(
                                  color: AppColors.white,
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: AppColors.white,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () {},
                                      child: Text("New group"),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {},
                                      child: Text("New broadcast"),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {},
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: ((context) =>
                                                    SettingsScreen()),
                                              ),
                                            );
                                          },
                                          child: Text("Setting")),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        storage.remove('name').then(
                                              (value) => Get.offAll(
                                                () => MobileScreen(),
                                              ),
                                            );
                                      },
                                      child: Text("Log Out"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                bottom: PreferredSize(
                  child: searchController.isSearch.value == true
                      ? SizedBox()
                      : Container(
                          padding: EdgeInsets.only(
                            top: height * 0.01,
                            // bottom: height * 0.005,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                          ),
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.04, right: width * 0.07),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: AppColors.white,
                                    size: Get.height * 0.03,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBar(
                                  indicatorWeight: 2.5,
                                  indicatorColor: AppColors.white,
                                  onTap: (value) {
                                    tabsController.selectedTabs(value);
                                  },
                                  controller: tabController,
                                  tabs: List.generate(
                                    tab.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: height * 0.008),
                                      child: tab[index],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  preferredSize: const Size.fromHeight(20),
                ),
              ),
            )
          ];
        },
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: TabBarView(
            physics: BouncingScrollPhysics(),
            controller: tabController,
            children: [
              Chats(search: searchText),
              Status(userImage: image),
              Calls(),
            ],
          ),
        ),
      ),
    );
  }
}
