import 'package:flutter/material.dart';

class DataTablePaginationController {
  int totalItems;
  int itemsPerPage;
  ScrollController _scrollController;
  int _currentPage;

  DataTablePaginationController({
    required this.totalItems,
    this.itemsPerPage = 10,
  })  : _currentPage = 0,
        _scrollController = ScrollController();

  int get currentPage => _currentPage;

  int get totalPages => (itemsPerPage == -1) ? 1 : (totalItems / itemsPerPage).ceil();

  ScrollController get scrollController => _scrollController;

  int get startItem => _currentPage * itemsPerPage;

  int get endItem => (itemsPerPage == -1)
      ? totalItems
      : ((_currentPage + 1) * itemsPerPage) > totalItems
          ? totalItems
          : ((_currentPage + 1) * itemsPerPage);

  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      _scrollController.jumpTo(0);
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _scrollController.jumpTo(0);
    }
  }

  void setItemsPerPage(int itemsPerPage) {
    this.itemsPerPage = itemsPerPage;
    _currentPage = 0;
    _scrollController.jumpTo(0);
  }

  void dispose() {
    _scrollController.dispose();
  }
}
