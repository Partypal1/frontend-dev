import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:partypal/constants/route_paths.dart';
import 'package:partypal/services/profile_provider.dart';
import 'package:partypal/widgets/app_bars/app_bar.dart';
import 'package:partypal/widgets/buttons/filled_button.dart';
import 'package:partypal/widgets/cards/circle_profile_image.dart';
import 'package:partypal/widgets/others/placeholders.dart';
import 'package:partypal/widgets/others/scrim.dart';
import 'package:partypal/widgets/others/shimmer.dart';
import 'package:partypal/widgets/others/tonal_elevation.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{
  late TabController _tabController;
  bool _isRefreshing = false;
  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.tonalElevation(Elevation.level1, context),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async{
          setState(() => _isRefreshing = true);
          await Future.delayed(Durations.extralong4).then((_){
            setState(() => _isRefreshing = false);
          });
          // TODO: refresh profile page content
          return Future.delayed(Duration.zero);
        }
        ,
        child: Scrim(
          active: _isRefreshing,
          child: Shimmer(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: SliverCustomAppBarDelegate(
                    title: 'Profile',
                    hasBackButton: false
                  ),
                  floating: true,
                ),
            
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          profile.user == null
                          ? const CircleProfileImageLoading(radius: 40,)
                          : CircleProfileImage(imageUrl: profile.user!.profileImageUrl, radius: 40,),
                          10.horizontalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              profile.user == null
                              ? const TextPlaceHolder(height: 16, width: 120)
                              : Text(
                                  '${profile.user!.firstName} ${profile.user!.lastName}',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
            
                              profile.user == null
                              ? const TextPlaceHolder(height: 12, width: 80)
                              : Text(
                                profile.user!.username,
                                style: Theme.of(context).textTheme.bodySmall
                              ),
            
                              profile.user == null
                              ? const TextPlaceHolder(height: 12, width: 100)
                              : Text(
                                'Partypal points: ${profile.user!.partypalPoints}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            
                SliverToBoxAdapter(
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const CustomFilledButton(label: 'Edit profile',),
                        10.horizontalSpace,
                        CustomFilledButton(
                          label: 'Settings',
                          onTap: (){
                            GoRouter.of(context).push(RoutePaths.settingsScreen);
                          },
                        ),
                      ]
                    ),
                  ),
                ),
            
                SliverPersistentHeader(
                  delegate: PersitentProfileHeaderDelegate(tabController: _tabController),
                  pinned: true,
                ),
            
                const SliverToBoxAdapter(
                  child: SizedBox(height: 2500,),
                )
            
              ],
            ),
          ),
        ),
      )
     );
  }
}

class PersitentProfileHeaderDelegate extends SliverPersistentHeaderDelegate{
  final TabController tabController;
  PersitentProfileHeaderDelegate({
    required this.tabController,
  });

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  bool shouldRebuild(PersitentProfileHeaderDelegate oldDelegate){
    return false;
  }
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent){
    return SizedBox(
      height: 80,
      child: TabBar(
        controller: tabController,
        splashBorderRadius: BorderRadius.circular(4),
        tabs: const [
          SizedBox(
            height: 50,
            child: Center(
              child: Text('Moments'),
            ),
          ),
          SizedBox(
            height: 50,
            child: Center(
              child: Text('Followers'),
            ),
          ),
          SizedBox(
            height: 50,
            child: Center(
              child: Text('Following'),
            ),
          ),
        ],
      ),
    );
  }
}