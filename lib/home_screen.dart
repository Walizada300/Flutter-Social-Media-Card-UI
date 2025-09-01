import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 5; // چون ۵ آیتم داری
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  final List<Map<String, String>> persons = [
    {
      "name": "Rashid Khan",
      "image": "assets/images/rashid.png",
      "description":
          "Rashid Khan Arman is an Afghan international cricketer and captain of the Afghanistan national team in the T20 format.",
    },
    {
      "name": "Farhad Darya",
      "image": "assets/images/darya.png",
      "description":
          "Farhad Darya is a highly acclaimed Afghan singer, composer, music producer, and philanthropist, active since the 1980s.",
    },
    {
      "name": "Hamid Karzai",
      "image": "assets/images/karzai.png",
      "description":
          "Hamid Karzai, born on December 24, 1957, is an Afghan politician who served as the first elected president of Afghanistan from 2004 to 2014.",
    },
    {
      "name": "Asif Jalali",
      "image": "assets/images/jalali.png",
      "description":
          "Asif Jalali was a prominent Afghan comedian and TV personality. He gained fame for his political satire and stand-up comedy. ",
    },
    {
      "name": "Abdul Baes Walizadah",
      "image": "assets/images/baes.jpg",
      "description":
          "Full-Stack developer and Flutter enthusiast. Loves to create beautiful and functional mobile applications.",
    },
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Social Media Cards"),
        backgroundColor: Colors.white,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 550,
              child: PageView.builder(
                controller: _pageController,
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  double scale = _currentPage == index ? 1.0 : 0.9;
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300),
                    tween: Tween(begin: scale, end: scale),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SocialMediaCardComponent(
                            name: persons[index]['name'],
                            description: persons[index]['description'],
                            followers: "${index + 1}M",
                            posts: "${index + 223}",
                            views: "${index + 150}M",
                            imageAddress: persons[index]['image'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}

class SocialMediaCardComponent extends StatefulWidget {
  const SocialMediaCardComponent({
    super.key,
    this.name,
    this.description,
    this.followers,
    this.views,
    this.posts,
    this.imageAddress,
  });

  final String? name, description, followers, views, posts, imageAddress;

  @override
  State<SocialMediaCardComponent> createState() =>
      _SocialMediaCardComponentState();
}

class _SocialMediaCardComponentState extends State<SocialMediaCardComponent> {
  bool isFollowing = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                widget.imageAddress ?? 'assets/images/rashid.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 6,
                            children: [
                              Text(
                                widget.name ?? "Rashid Khan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/svg/Verified.svg',
                                color: Colors.blue,
                                height: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.description ??
                                "Rashid Khan Arman is an Afghan international cricketer and captain of the Afghanistan national team in the T20 format.",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: StatusWidget(
                                  title: widget.followers ?? "12.5M",
                                  subTitle: "Followers",
                                ),
                              ),
                              DividerWidget(),
                              Expanded(
                                child: StatusWidget(
                                  title: widget.views ?? "885M",
                                  subTitle: "Views",
                                ),
                              ),
                              DividerWidget(),
                              Expanded(
                                child: StatusWidget(
                                  title: widget.posts ?? "290",
                                  subTitle: "Posts",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isFollowing = !isFollowing;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white60,
                                          offset: Offset(1, 1),
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        Icon(
                                          isFollowing
                                              ? Icons.minimize
                                              : Icons.add,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          isFollowing ? "Unfollow" : "Follow",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 26,
                                      ),

                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(60),
                                        border: Border.all(
                                          color: Colors.white12,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/message.svg",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 1,
      decoration: BoxDecoration(color: Colors.white60),
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, this.title, this.subTitle});

  final String? title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title ?? "12.5M",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          subTitle ?? "Followers",
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }
}
