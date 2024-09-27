// lib/widgets/site_details_overlay.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepback/src/presentation/historical_sites/historical_sites_cubit.dart';
import '../models/wikipedia_page_response.dart' as wiki;

class SiteDetailsOverlay extends StatelessWidget {
  final wiki.Page sitePage;

  const SiteDetailsOverlay({Key? key, required this.sitePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Make background transparent
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  // Clear the selected site
                  BlocProvider.of<HistoricalSitesCubit>(context).clearSelectedSite();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            // Site title
            Text(
              sitePage.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Site image
            if (sitePage.thumbnail != null)
              Image.network(
                sitePage.thumbnail!.source,
                height: 80.0,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 8.0),
            // Site description
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  sitePage.extract,
                  style: const TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
