import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:stepback/src/models/wikipedia_geo_search_response.dart';
import 'package:stepback/src/models/wikipedia_page_response.dart' as wiki;
import 'package:stepback/src/presentation/historical_sites/historical_sites_cubit.dart';
import 'package:stepback/src/widgets/historical_site_details.dart';



class NearbySitesWidget extends StatefulWidget {
  final List<GeoSearchResult> sites;
  final GeoSearchResult selectedSite;

  const NearbySitesWidget({super.key, required this.sites, required this.selectedSite});

  @override
  State<NearbySitesWidget> createState() => _NearbySitesWidgetState();
}

class _NearbySitesWidgetState extends State<NearbySitesWidget> {
  late HistoricalSitesCubit cubit;

  @override
  void initState() {    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit = BlocProvider.of<HistoricalSitesCubit>(context);
    });
  }


  void _showSiteDetails(BuildContext context, GeoSearchResult site) {
    // Fetch site details and update the state
    cubit.fetchSiteDetails(site);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0,
      left: 5.0,
      width: 150.0, // Fixed width for the small window
      height: 200.0, // Fixed height for the small window
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nearby Sites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget.sites.length,
                itemBuilder: (context, index) {
                  final site = widget.sites[index];
                  final isSelectedSite = widget.selectedSite.pageid == site.pageid;
                  return ListTile(
                    selected: isSelectedSite,
                    selectedColor: Colors.blue.withOpacity(0.7),
                    title: Text(
                      site.title,
                      style:
                         TextStyle(
                          color: isSelectedSite ? Colors.blue : Colors.white,
                          fontSize: isSelectedSite ? 14.0 : 12.0,
                          fontWeight: isSelectedSite ? FontWeight.bold : FontWeight.normal,)
                    ),
                    subtitle: Text(
                      '${site.dist.toStringAsFixed(1)} meters away',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 10),
                    ),
                    onTap: () {
                      // Update the selected site in the cubit
                      cubit.selectSite(site);
                      _showSiteDetails(context, site);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
