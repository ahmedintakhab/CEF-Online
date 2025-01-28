import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FilterSheet extends StatefulWidget {
  final String query;
  final Function(List<dynamic>) onFilterApplied;
  const FilterSheet({Key? key, required this.query, required this.onFilterApplied}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  RangeValues _currentRangeValues = const RangeValues(0, 20000);
  List<Map<String, dynamic>> categoryData = [];
  bool activevalue = false;
  List <String> categoryList = [];
  List <String> selectedCategory = [];
  double slidervalue = 0;
  double rate = 0;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState (){
    super.initState();
    fetchCategories (); //Fetch categories on page load
  }
  Future<void> fetchCategories() async {
    final url = Uri.parse('https://cefonlineacademy.com/api/frontend/all-categories-with-names');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200){
        final data = json.decode(response.body);
        print('API Status Code: ${response.statusCode}');
        setState(() {
          categoryList = data.map<String>((category) => category['category_name'].toString()).toList();
          categoryData = List<Map<String, dynamic>>.from(data);
          print('API Successfully Fetched data: $categoryData');
          isLoading = false;

        });
      }
      else{
        setState(() {
              errorMessage = 'Failed to load categories. Please try again.';
               isLoading = false;
        });
      }
    } catch(e){
      setState(() {
        errorMessage = 'An error occured: $e';
        isLoading = false;
      });
    }
  }
  //Filter API Calling function
  Future<void> applyFilter() async {
    final url = Uri.parse('https://cefonlineacademy.com/api/frontend/course/search');

    try {
      // Map selected category names to IDs
      final selectedCategoryIds = categoryData
          .where((category) => selectedCategory.contains(category['category_name']))
          .map((category) => category['category_id'])
          .toList();

      // Print the values being sent in the API call
      print('Query: ${widget.query}');
      print('Min Price: ${_currentRangeValues.start}');
      print('Max Price: ${_currentRangeValues.end}');
      print('Rating: $rate');
      print('Selected Categories: $selectedCategoryIds');

      final response = await http.post(
        url,
        body: json.encode({
          'query': widget.query,
          'min_price': _currentRangeValues.start,
          'max_price': _currentRangeValues.end,
          'rating': rate,
          'categories': selectedCategoryIds,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Filter API Status Code: ${response.statusCode}');
        print('API Successfully filter data');
        // widget.onFilterApplied(data);
        // Extract course results from the response
        final List<dynamic> results = data['course_results'] ?? [];
        widget.onFilterApplied(results);
        Navigator.pop(context);
      } else {
        print('Failed to Apply filter. Please try again.');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to apply filter. Please try again.')),
        // );
      }
    } catch (e) {
      print('An error occurred: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('An error occurred: $e')),
      // );
    }
  }

  void clearAllFilters() {
    setState(() {
      _currentRangeValues = const RangeValues(0, 20000);
      selectedCategory.clear();
      rate = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    print('check the query after passing: ${widget.query}');
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Filter",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Price range",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                  "\Rs.${_currentRangeValues.start.round().toString()}-\Rs.${_currentRangeValues.end.round().toString()}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold))
            ],
          ),
          RangeSlider(
            activeColor: Color(0XFF8CC13F),
            values: _currentRangeValues,
            min: 0,
            max: 20000,
            divisions: 20,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
          const SizedBox(height: 10),
          const Text(
            "Ratings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              RatingBar.builder(
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rate = rating;
                  });
                },
              ),
              const SizedBox(width: 20),
              Text(
                "${rate}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              for (final category in categoryData)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!selectedCategory.contains(category['category_name'])) {
                              selectedCategory.add(category['category_name']);
                            } else {
                              selectedCategory.remove(category['category_name']);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 13),
                          decoration: BoxDecoration(
                            color: selectedCategory.contains(category['category_name'])
                                ? Color(0XFFEBF2C2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                                color:
                                    selectedCategory.contains(category['category_name'])
                                        ? Color(0XFF23408F)
                                        : Color(0XFF6E758A),
                                width: 1),
                          ),
                          child: Text(
                            category['category_name'],
                            style: selectedCategory.contains(category['category_name'])
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF23408F),
                                    fontFamily: 'Gilroy')
                                : const TextStyle(
                                    color: Color(0XFF6E758A),
                                    fontFamily: 'Gilroy'),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: applyFilter,
                  child: Container(
                    height: 56,
                    width: 157,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Color(0XFF78A03F),
                    ),
                    child: const Center(
                        child: Text(
                      "Apply",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0XFFFFFFFF),
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: clearAllFilters,
                  child: Container(
                    height: 56,
                    width: 157,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      color: Color(0XFFB7B7B7)
                    ),
                    child: const Center(
                        child: Text(
                      "Clear All",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
