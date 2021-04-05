import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:flutter/material.dart';
import 'multi_select_item.dart';

/// Contains common actions that are used by different multi select classes.
class MultiSelectActions<V> {
  List<V> onItemCheckedChange(
      List<V> selectedValues, V itemValue, bool checked) {
    if (checked) {
      selectedValues.add(itemValue);
    } else {
      selectedValues.remove(itemValue);
    }
    return selectedValues;
  }

  /// Pops the dialog from the navigation stack and returns the initially selected values.
  void onCancelTap(BuildContext ctx, List<V> initiallySelectedValues) {
    Navigator.pop(ctx, initiallySelectedValues);
  }

  /// Pops the dialog from the navigation stack and returns the selected values.
  /// Calls the onConfirm function if one was provided.
  void onConfirmTap(
      BuildContext ctx, List<V> selectedValues, Function(List<V>) onConfirm) {
    Navigator.pop(ctx, selectedValues);
    if (onConfirm != null) {
      onConfirm(selectedValues);
    }
  }

  /// Accepts the search query, and the original list of items.
  /// If the search query is valid, return a filtered list, otherwise return the original list.
  List<MultiSelectItem<V>> updateSearchQuery(
      String val, List<MultiSelectItem<V>> allItems) {
    if (val != null && val.trim().isNotEmpty) {
      List<MultiSelectItem<V>> filteredItems = [];
      for (var item in allItems) {
        if (item.label.toLowerCase().contains(val.toLowerCase())) {
          filteredItems.add(item);
        }
      }
      return filteredItems;
    } else {
      return allItems;
    }
  }

  List<MultiSelectItem<V>> updateSearchQueryForInsurance(
      String val, List<MultiSelectItem<V>> allItems) {
    if (val != null && val.trim().isNotEmpty) {
      List<MultiSelectItem<V>> filteredItems = [];
      for (var item in allItems) {
        DiseaseDTO dto = item.value as DiseaseDTO;
        if (dto.name.toLowerCase().contains(val.toLowerCase()) &&
            !filteredItems.contains(item)) {
          filteredItems.add(item);
        } else {
          if (dto.diseaseId.toLowerCase().contains(val[0].toLowerCase())) {
            var listDiseases = dto.diseaseId.split('-');
            if (listDiseases.length > 1) {
              int num1 = int.parse(listDiseases[0].substring(1));
              int num2 = int.parse(listDiseases[1].substring(1));
              if (val.substring(1) != '') {
                if (num1 <= int.parse(val.substring(1)) &&
                    int.parse(val.substring(1)) <= num2 &&
                    !filteredItems.contains(item)) {
                  filteredItems.add(item);
                }
              } else {
                if (dto.diseaseId.toLowerCase().contains(val.toLowerCase()) &&
                    !filteredItems.contains(item)) {
                  filteredItems.add(item);
                }
              }
            } else {
              if (dto.diseaseId.toLowerCase().contains(val.toLowerCase()) &&
                  !filteredItems.contains(item)) {
                filteredItems.add(item);
              }
            }
          }
        }
      }

      return filteredItems;
    } else {
      return allItems;
    }
  }

  /// Toggles the search field.
  bool onSearchTap(bool showSearch) {
    return !showSearch;
  }
}
