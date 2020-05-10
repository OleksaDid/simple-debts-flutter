import 'package:flutter/material.dart';
import 'package:simpledebts/widgets/image_lazy_load.dart';

class UserTopBlock extends StatelessWidget {
  final String imageUrl;
  final String title;
  final void Function() onImageTap;

  UserTopBlock({
    @required this.imageUrl,
    @required this.title,
    this.onImageTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onImageTap,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 3, color: Colors.white),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: ImageLazyLoad(NetworkImage(imageUrl))
            )
          )
        ),
        SizedBox(height: 10,),
        Text(
          title,
          style: Theme.of(context).textTheme.headline4.copyWith(
            color: Colors.white
          ),
        )
      ],
    );
  }

}