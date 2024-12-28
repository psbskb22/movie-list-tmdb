import 'package:flutter/material.dart';

class MovieListErrorWidget extends StatelessWidget {
  final String errorMessage;
  const MovieListErrorWidget({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 50,
          color: Colors.redAccent,
        ),
        Text(errorMessage),
        MaterialButton(
          onPressed: () {},
          minWidth: 200,
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Retry",
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        )
      ],
    ));
  }
}
