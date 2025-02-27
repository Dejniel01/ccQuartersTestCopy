import 'package:ccquarters/common_widgets/error_message.dart';
import 'package:ccquarters/common_widgets/message.dart';
import 'package:ccquarters/model/house.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'item.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({
    super.key,
    required this.pagingController,
    required this.getHouses,
  });

  final PagingController<int, House> pagingController;
  final Future<List<House>?> Function(int, int) getHouses;

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  final _numberOfPostsPerRequest = 10;

  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var houses = await widget.getHouses(pageKey, _numberOfPostsPerRequest);

      if (houses == null) {
        widget.pagingController.error = true;
        return;
      }

      final isLastPage = houses.length < _numberOfPostsPerRequest;

      if (isLastPage) {
        widget.pagingController.appendLastPage(houses);
      } else {
        var nextPageKey = pageKey + 1;
        widget.pagingController.appendPage(houses, nextPageKey);
      }
    } catch (e) {
      widget.pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: PagedListView<int, House>(
          scrollDirection: Axis.horizontal,
          pagingController: widget.pagingController,
          builderDelegate: PagedChildBuilderDelegate<House>(
            noItemsFoundIndicatorBuilder: (context) => const Message(
              title: "Niestety nie znaleziono dla \nCiebie żadnych ogłoszeń",
              subtitle: "Spróbuj ponownie później",
              icon: Icons.home,
              adjustToLandscape: true,
              padding: EdgeInsets.all(8.0),
            ),
            firstPageErrorIndicatorBuilder: (context) => const ErrorMessage(
              "Nie udało się pobrać ogłoszeń",
              tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
            ),
            newPageErrorIndicatorBuilder: (context) => const ErrorMessage(
              "Nie udało się pobrać ogłoszeń",
              tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
            ),
            itemBuilder: (context, item, index) => LayoutBuilder(
              builder: (context, constraints) => HouseItem(
                house: item,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
