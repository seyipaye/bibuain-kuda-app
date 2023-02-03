/* // ignore_for_file: must_be_immutable, unused_local_variable, unnecessary_statements, unnecessary_null_comparison

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../customers/core/app_routes.dart';
import '../customers/core/extentions.dart';
import '../customers/data/home/home_category.dart';
import '../customers/data/home/home_item.dart';
import '../customers/data/retaurant/restaurant_menu_item.dart';
import '../customers/domain/repositories/auth_repo.dart';
import '../customers/presentation/modules/customers/home/controller/home_controller.dart';
import '../customers/presentation/modules/customers/home/widgets/home_list_item.dart';
import '../customers/presentation/modules/customers/home/widgets/trending_item.dart';
import '../customers/presentation/modules/drawer/drawer.dart';
import '../customers/presentation/utils/colors.dart';
import '../customers/presentation/utils/constants.dart';
import '../customers/presentation/utils/strings.dart';
import '../customers/presentation/utils/validators.dart';
import '../customers/presentation/widgets/app_card.dart';
import '../customers/presentation/widgets/app_text_form_field.dart';
import '../customers/presentation/widgets/pages/empty_page.dart';
import '../customers/presentation/widgets/rounded_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/dish_home_list_item.dart';

class HomePage extends GetView<HomeScreenController> {
  HomePage({Key? key}) : super(key: key);

  // final List<String> tabList = <String>[
  //   'Near You',
  //   'Pocket-friendly',
  //   'Discounted dishes',
  // ];
  Vouchers? vouchers;

  final voucherRes = <Vouchers>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: 180,
          height: 30,
          child: ElevatedButton(
            onPressed: controller.onAddressPressed,
            style: ElevatedButton.styleFrom(
              textStyle: Get.textTheme.labelSmall,
              elevation: 2,
              padding: EdgeInsets.only(left: 11, right: 11),
            ),
            child: Row(
              children: [
                Obx(() {
                  return Expanded(
                      child: Text(
                    controller.user.value.customerProfile?.address?.text == null
                        ? 'Add address'
                        : controller.user.value.customerProfile!.address!.text!,
                    overflow: TextOverflow.ellipsis,
                  ));
                }),
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 5),
            child: Obx(() {
              if (HomeScreenController.instance.cartItem.value == 0)
                return IconButton(
                  icon: ImageIcon2.asset('assets/icons/shopping_cart.png'),
                  onPressed: () {
                    Get.toNamed(Routes.cart);
                  },
                );

              return badges.Badge(
                toAnimate: false,
                shape: badges.BadgeShape.circle,
                badgeColor: AppColors.primary,
                position: badges.BadgePosition.topEnd(top: -3, end: -3),
                padding: EdgeInsets.all(6),
                badgeContent: Text(
                  '${HomeScreenController.instance.cartItem.value}',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                child: IconButton(
                  icon: ImageIcon2.asset('assets/icons/shopping_cart.png'),
                  onPressed: () {
                    Get.toNamed(Routes.cart);
                  },
                ),
              );
            }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: controller.obx(
        _buildBody,
        onLoading: Center(child: CircularProgressIndicator()),
        onEmpty: EmptyPage(
          'assets/images/rafiki.svg',
          title: "Sorry, we couldn't find a restuarant close to you",
          desc: AuthRepository.instance.user.value.customerProfile?.address ==
                  null
              ? 'Enter an address above to show you nearby vendors'
              : 'We are yet to begin delivery within your location, but we are working tirelessly to bring Foodelo to you',
          extras: AuthRepository.instance.user.value.customerProfile?.address !=
                  null
              ? TextButton(
                  child: Text('Submit a location'),
                  onPressed: () {
                    launchUrl(
                      Uri.parse(
                          'https://docs.google.com/forms/d/e/1FAIpQLSe0aKMUBkb_t8WRWXK7axxtQ6c4NctoWDDW3AnVlJGpeOn8Qw/viewform?usp=sf_link'),
                    );
                  },
                )
              : null,
        ),
        onError: (error) => EmptyPage(
          'assets/images/rafiki.svg',
          title: "Couldn't find a restaurant\nclose to you!",
          desc: '',
          extras: TextButton(
            child: Text('Retry'),
            onPressed: () {
              controller.fetchData();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    List<HomeCategory>? homeCategories,
  ) {
    return RefreshIndicator(
      onRefresh: controller.fetchData,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 36, top: 20),
              child: Obx(() {
                return SizedBox(
                  height: 55,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.tabList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _dashboardChips(
                        index,
                        homeCategories!,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          //voucherData(),

          if (controller.selectedIndex.value == 0)
            carouselList(homeCategories!),

          //nearYouList(homeCategories!),

          _homeDataResults(homeCategories!),
        ],
      ),
    );
  }

  /* SliverToBoxAdapter newlyAdded(List<HomeCategory> homeCategories){
    return SliverToBoxAdapter(
      child:
  }
*/
  SliverToBoxAdapter carouselList(List<HomeCategory> homeCategories) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 44),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 20, 24),
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      DefaultTextStyle(
                        style: Get.textTheme.titleSmall!.copyWith(
                          fontSize: 14,
                          fontFamily: 'Cabin',
                        ),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            // RotateAnimatedText('Trending Now'),
                            //WavyAnimatedText('Trending Now'),
                            FlickerAnimatedText('Trending Now'),
                            //RotateAnimatedText('DIFFERENT'),
                          ],
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return CarouselSlider(
                options: CarouselOptions(
                    height: 250.0, viewportFraction: 0.63, autoPlay: true),
                items: [
                  if (controller.voucherDetails.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Stack(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/offer.png',
                                height: 240,
                                width: 203,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          //spacer(),

                          /*Positioned(
                            top:14,
                            left: 14,
                            right:30,
                            child: Text('OFFER!!!',
                            style:Get.textTheme.headlineLarge!.copyWith(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: 'Cabin',
                              fontWeight: FontWeight.w700
                            ) ,),
                          ),*/
                          Positioned(
                              top: 121,
                              left: 14,
                              right: 24,
                              //bottom: 40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  controller.voucher.value.type ==
                                          'price_discount'
                                      ? Text(
                                          'You’ve got ${controller.voucher.value.discount}% \noff your next order',
                                          // controller.availableDiscount.value.first.toString(),
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            letterSpacing: 1,
                                            height: 1.25,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        )
                                      : Text(
                                          'Free delivery on \nyour first order',
                                          // controller.availableDiscount.value.first.toString(),
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            letterSpacing: 1,
                                            height: 1.25,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                  // spacer(h: 10),
                                ],
                              )),
                          Positioned(
                            left: 14,
                            bottom: 48,
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(right: 30),
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(3, 6, 3, 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                // 'Offer valid until ${convertStringToDateTime(vouchers.expiryDate.toString())}',
                                'Offer valid until ${DateFormat('MMM d').format(DateTime.parse(controller.voucher.value.expiryDate!.toString()).add(Duration(hours: 1)))}',
                                // convertStringTime(controller.),
                                style: Get.textTheme.bodyText2!
                                    .copyWith(fontSize: 10, height: 1.05),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (controller.trendingVendors.isNotEmpty)
                    ...List.generate(controller.trendingVendors[0].items.length,
                        (index) {
                      final item = controller.trendingVendors[0].items[index];
                      var isOpenRest;
                      // Build Items
                      if (item.type == HomeItemType.restaurant) {
                        final restaurant = item.restaurant;
                        isOpenRest = restaurant.open;
                        return TrendingListItem(
                          title: restaurant.restaurantName,
                          iconUrl: restaurant.image ?? kUrl,
                          isOpen: restaurant.open,
                          imageUrl: restaurant.coverPhoto ?? '',
                          restaurant: restaurant,
                          //resturant.coverPhoto,
                          onPressed: () {
                            Get.toNamed(
                              Routes.resturant,
                              arguments: restaurant.id,
                            );
                          },
                        );
                      } else
                        return Container();
                    })
                ]);
          }),
        ],
      ),
    ));
  }

  SliverToBoxAdapter voucherData() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.voucherDetails.isNotEmpty)
          return Stack(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/voucher-cover.jpg',
                    height: 240,
                    width: 203,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              spacer(),
              Positioned(
                  top: 121,
                  left: 14,
                  right: 24,
                  //bottom: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.voucher.value.type == 'price_discount'
                          ? Text(
                              'You’ve got ${controller.voucher.value.discount}% \noff your next order',
                              // controller.availableDiscount.value.first.toString(),
                              style: Get.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 1,
                                height: 1.25,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                          : Text(
                              'Free delivery on \nyour first order',
                              // controller.availableDiscount.value.first.toString(),
                              style: Get.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 1,
                                height: 1.25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                      spacer(h: 10),
                      Container(
                        width: 140,
                        margin: EdgeInsets.only(right: 30),
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(1, 6, 1, 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          // 'Offer valid until ${convertStringToDateTime(vouchers.expiryDate.toString())}',
                          'Offer valid until ${DateFormat('MMM d').format(DateTime.parse(controller.voucher.value.expiryDate!.toString()).add(Duration(hours: 1)))}',
                          // convertStringTime(controller.),
                          style: Get.textTheme.bodyText2!
                              .copyWith(fontSize: 10, height: 1.05),
                        ),
                      ),
                    ],
                  )),
              spacer(),
              /* Positioned(
                left: 20,
                bottom: 20,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    // 'Offer valid until ${convertStringToDateTime(vouchers.expiryDate.toString())}',
                    'Offer valid until ${convertStringToDateTime(controller.voucher.value.expiryDate!.toString())}',
                    // convertStringTime(controller.),
                    style: Get.textTheme.bodyText2!.copyWith(fontSize: 12),
                  ),
                ),
              ),*/
            ],
          );

        return SizedBox();
      }),
    );
  }

  _dashboardChips(int index, List<HomeCategory> homeCategories) {
    return GestureDetector(
      onTap: () {
        controller.toggle(index);
        //controller.selectedTab(controller.tabList[index]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: controller.selectedIndex.value == index
              ? AppColors.primary
              : Color(0xFFF7F7FC5).withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            controller.tabList[index],
            style: Get.textTheme.bodyText1!.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cabin',
              color: controller.selectedIndex.value == index
                  ? AppColors.whiteColor
                  : AppColors.buttonText,
            ),
          ),
        ),
      ),
    );
  }

  _homeDataResults(List<HomeCategory> homeCategories) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Obx(() {
        if (controller.homepage.value == HomepageTab.all)
          return Column(
            children: [
              //All restaurant
              _buildFilterItem(homeCategories[0], onMorePressed: () {
                Get.toNamed(Routes.homeSection,
                    arguments: controller.allVendors[0]);
              }),
              //Near you
              if (homeCategories[1].items.isNotEmpty)
                _buildFilterItem(homeCategories[1], onMorePressed: () {
                  Get.toNamed(Routes.homeSection,
                      arguments: controller.nearbyVendors[0]);
                }),

              //Pockect friendly
              if (homeCategories[2].items.isNotEmpty)
                _buildFilterItem(homeCategories[2], onMorePressed: () {
                  Get.toNamed(Routes.homeSection,
                      arguments: controller.allPocketFriendly[0]);
                }),

              //Discount offers
              if (homeCategories[3].items.isNotEmpty)
                _buildMenuFilterItem(homeCategories[3], onMorePressed: () {
                  Get.toNamed(Routes.homeSection,
                      arguments: controller.availableDiscountDish[0]);
                }),
            ],
          );

        if (controller.homepage.value == HomepageTab.near_you) {
          if (controller.nearbyVendors[0].items.isEmpty) {
            return SuggestARestaurant(
              title: 'Near You',
            );
          }
          return _buildFilterItem(homeCategories[1], horizoScroll: false,
              onMorePressed: () {
            Get.toNamed(Routes.homeSection,
                arguments: controller.nearbyVendors[0]);
          });
        }

        if (controller.homepage.value == HomepageTab.newly_added) {
          if (controller.newlyAddedVendors[0].items.isEmpty) {
            return SuggestARestaurant(title: 'Newly Added');
          }

          return _buildFilterItem(controller.newlyAddedVendors[0],
              horizoScroll: false, onMorePressed: () {
            Get.toNamed(Routes.homeSection,
                arguments: controller.newlyAddedVendors[0]);
          });
        }

        if (controller.homepage.value == HomepageTab.pocket) {
          if (controller.allPocketFriendly[0].items.isEmpty) {
            return Center(
              child: Text('Oops!! no pocket friendly '),
            );
          }

          return _buildFilterItem(controller.allPocketFriendly[0],
              horizoScroll: false, onMorePressed: () {
            Get.toNamed(Routes.homeSection,
                arguments: controller.allPocketFriendly[0]);
          });
        }

        if (controller.homepage.value == HomepageTab.most_rated) {
          if (controller.mostRated.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Please rate a restaurant you have ordered from before',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        //flex:2,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  spacer(),
                  AppTextFormField(
                    hintText: 'Find Restaurants',
                    prefixIcon: IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/icons/search.png'),
                      ),
                      onPressed: () {
                        //      Get.toNamed(Routes.restaurantRating);
                      },
                    ),
                  ),
                  spacer(),
                  SizedBox(
                      height: null,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.nearbyVendors[0].items.length,
                          itemBuilder: (context, index) {
                            final item =
                                controller.nearbyVendors[0].items[index];

                            final menu = item.restaurant!;
                            return AppMaterial(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(bottom: 32),
                              onTap: () {
                                // Get.to(()=>)
                              },
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    RoundedImage(
                                      menu.coverPhoto ?? kUrl,
                                      radius: 30,
                                      height: 56,
                                      width: 56,
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(menu.restaurantName!),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  List.generate(
                                                    menu.dishMenuItem!.length,
                                                    (index) {
                                                      return menu
                                                          .dishMenuItem![index]
                                                          .name!;
                                                    },
                                                  ).join(','),
                                                  style: Get
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          color: AppColors
                                                              .primary),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }))
                ],
              ),
            );
          }

          return _buildFilterItem(controller.allPocketFriendly[0],
              horizoScroll: false, onMorePressed: () {
            Get.toNamed(Routes.homeSection,
                arguments: controller.allPocketFriendly[0]);
          });
        }

        if (controller.availableDiscountDish[0].items.isEmpty) {
          return Center(
            child: Text('Oops!! No discounted menu yet'),
          );
        }

        return _buildMenuFilterItem(controller.availableDiscountDish[0],
            horizoScroll: false, onMorePressed: () {
          Get.toNamed(Routes.homeSection,
              arguments: controller.availableDiscountDish[0]);
        });

        /*if (controller.isLoading.isFalse) {
              return Center(
                child: CircularProgressIndicator().reactive(),
              );
            }
            else if (controller.selectedTab.value == null ||
                controller.selectedTab.value!.isEmpty) {
              return _buildFilterItem(
                homeCategories[index],
                onMorePressed: () {
                  if (index == 0)
                    Get.toNamed(Routes.homeSection,
                        arguments: controller.allHomeData[0]);
                  // arguments: controller.nearbyVendors[0]);
                  else if (index == 1)
                    Get.toNamed(Routes.homeSection,
                        arguments: controller.availableDiscount[0]);
                },
              );
            }
            else if (controller.selectedTab.value!
                .contains('Discounted dishes')) {
              return _buildMenuFilterItem(
                controller.homedata.value[index],
                onMorePressed: () {
                  if (index == 1)
                    Get.toNamed(
                      Routes.homeSection,
                      arguments: controller.availableDiscount[0],
                    );
                },
              );
            }
            else {
              return _buildFilterItem(
                controller.homedata.value[index],
                onMorePressed: () {
                  if (controller.selectedTab.value == 'Near You')
                    Get.toNamed(Routes.homeSection,
                        arguments: controller.nearbyVendors[0]);
                  else if (controller.selectedTab.value == 'Pocket-friendly')
                    Get.toNamed(Routes.homeSection,
                        arguments: controller.allPocketFriendly[0]);
                  else if (controller.selectedTab.value ==
                      'Discounted dishes')
                    Get.toNamed(Routes.homeSection,
                        arguments: controller.availableDiscount[0]);
                },
              );
            }
          }*/
      })
    ]));
  }

  Widget _buildFilterItem(HomeCategory category,
      {required VoidCallback onMorePressed, bool horizoScroll = true}) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          children: [
            // Build Header
            HeadingItem(
              (controller.selectedTab.value == null)
                  ? category.title
                  : controller.selectedTab.value!,
              onPressed: onMorePressed,
            ),
            SizedBox(height: 8),
            SizedBox(
              height: horizoScroll ? 330 : null,
              child: ListView.builder(
                shrinkWrap: true,
                physics: horizoScroll ? null : NeverScrollableScrollPhysics(),
                padding: horizoScroll
                    ? EdgeInsets.symmetric(horizontal: 24)
                    : EdgeInsets.zero,
                scrollDirection: horizoScroll ? Axis.horizontal : Axis.vertical,
                itemCount: category.items.length,
                itemBuilder: (context, index) {
                  final item = category.items[index];
                  var isOpenRest;
                  // Build Items
                  if (item.type == HomeItemType.restaurant) {
                    final restaurant = item.restaurant!;
                    isOpenRest = restaurant.open;
                    return HomeListItem(
                      title: restaurant.restaurantName,
                      iconUrl: restaurant.image ?? kUrl,
                      isOpen: restaurant.open,
                      imageUrl: restaurant.coverPhoto ?? '',
                      restaurant: restaurant,
                      horizonScrollAxis: horizoScroll,
                      //resturant.coverPhoto,
                      onPressed: () {
                        Get.toNamed(
                          Routes.resturant,
                          arguments: restaurant.id,
                        );
                      },
                    );
                  } else {
                    final items = item.discountedDishes!;
                    //final dish = items.menuItems as MenuItems;

                    return Container(); /* HomeListItem(
                      title: "hahahhahah",
                      iconUrl: dish.images != null ? dish.images!.first : kUrl,
                      description: dish.description,
                      deliveryTime: '${dish.prepTime} Minutes',
                      discount: dish.discount!,
                      imageUrl: dish.images!.first,
                      onPressed: () => Get.toNamed(Routes.dish, arguments: dish),
                    );*/
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMenuFilterItem(HomeCategory category,
      {required VoidCallback onMorePressed, bool horizoScroll = true}) {
    return Obx(() {
      //print("size of category is ${category.items.length}");
      return Column(
        children: [
          // Build Header
          HeadingItem(
            (controller.selectedTab.value == null)
                ? category.title
                : controller.selectedTab.value!,
            onPressed: onMorePressed,
          ),
          SizedBox(height: 8),
          SizedBox(
            height: horizoScroll ? 350 : null,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: horizoScroll ? Axis.horizontal : Axis.vertical,
                physics: horizoScroll ? null : NeverScrollableScrollPhysics(),
                padding: horizoScroll
                    ? EdgeInsets.symmetric(horizontal: 24)
                    : EdgeInsets.zero,
                itemCount: category.items.length,
                itemBuilder: (context, index) {
                  final rrr = category!.items[index];
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection:
                          horizoScroll ? Axis.horizontal : Axis.vertical,
                      physics:
                          horizoScroll ? null : NeverScrollableScrollPhysics(),
                      //padding: EdgeInsets.only(top: 16, bottom: 10),
                      itemCount: rrr.discountedDishes!.menuItems!.length,
                      itemBuilder: (context, index) {
                        final dish = rrr.discountedDishes!.menuItems![index];
                        var ratings = rrr.discountedDishes!.ratings!;
                        var distance = rrr.discountedDishes!.distance! / 1000;

                        return DishHomeListItem(
                          title: dish.name ?? '',
                          iconUrl:
                              dish.images != null ? dish.images!.first : kUrl,
                          description: dish.description ?? "",
                          deliveryTime: dish.prepTime!.toDouble(),
                          discount: dish.discount ?? 0,
                          imageUrl: dish.images!.first,
                          ratings: ratings,
                          distance: distance,
                          horizonScrollAxis: horizoScroll,
                          onPressed: () {
                            var dii = DishMenuItems(
                                name: dish.name,
                                images: dish.images,
                                originalPrice: dish.originalPrice,
                                sellingPrice: dish.sellingPrice,
                                id: dish.id);
                            Get.toNamed(Routes.dish, arguments: dii);
                          },
                        );
                      });
                }),
          ),
        ],
      );
    });
  }
}

class SuggestARestaurant extends GetView<HomeScreenController> {
  const SuggestARestaurant({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              /*Text(
                  'Oops!! No $title restaurant yet '),
            spacer(),*/
              Text(
                  'Do you have or know a restaurant we should on-board? Please enter the name and address of restaurant below  '),
              spacer(),
              AppTextFormField(
                label: 'Restaurant Name',
                hintText: 'e.g Amala Skye',
                textEditingController: controller.restaurantNameController,
                onSaved: (val) => controller.restaurantName = val!,
                validator: Validator.isNotEmpty,
              ),
              spacer(),
              AppTextFormField(
                label: 'Restaurant Location',
                hintText: '',
                textEditingController: controller.restaurantLocationController,
                onSaved: (val) => controller.restaurantLocation = val!,
                validator: Validator.isNotEmpty,
              ),
              spacer(h: 50),
              ElevatedButton(
                  onPressed: () {
                    controller.suggestRestaurant();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  child: Text('Done'))
            ],
          ),
        ),
      ),
    );
  }
}

class HeadingItem extends StatelessWidget {
  final String heading;
  final VoidCallback? onPressed;

  HeadingItem(this.heading, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            heading,
            style: Get.textTheme.titleSmall!.copyWith(fontSize: 14),
          )),
          TextButton(
            onPressed: onPressed,
            child: Row(
              children: [
                Text('View all'),
                spacer(w: 10),
                Icon(Icons.arrow_forward),
              ],
            ),
            style: TextButton.styleFrom(
              textStyle: Get.textTheme.titleSmall!.copyWith(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
 */