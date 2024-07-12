import 'package:colyak/views/screens/reportdetailpage.dart';
import 'package:colyak/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:colyak/models/auth_model.dart';
import 'package:colyak/models/service/api_service.dart';
import 'package:colyak/models/meals_report.dart';


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<MealReport> _mealReports = [];
  bool _isLoading = true;
  String _selectedFilter = 'Last 30 Days';
  final DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
}

void _fetchData() async {
  try {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    final apiService = ApiService();
    final mealReports = await apiService.getMealReport(
      authModel.email!,
      DateFormat('yyyy-MM-dd').format(_startDate),
      DateFormat('yyyy-MM-dd').format(_endDate),
      authModel.token!,
    );
    print("Fetched meal reports: $mealReports"); // Debug print
    if (mealReports.isNotEmpty) {
      if (mounted) {
        setState(() {
          _mealReports = mealReports;
          _isLoading = false;
          _mealReports.sort((a, b) => -1 * DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
        });

      }
    } else {
      print("Meal reports are null or empty"); // Debug print
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  } catch (e) {
    print("Error fetching meal reports: $e"); // Debug print
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      switch (filter) {
        case 'Son 7 Gün':
          _startDate = _endDate.subtract(const Duration(days: 7));
          break;
        case 'Son 1 Ay':
          _startDate = _endDate.subtract(const Duration(days: 30));
          break;
        case 'Son 3 Ay':
          _startDate = _endDate.subtract(const Duration(days: 90));
          break;
        default:
          _startDate = _endDate.subtract(const Duration(days: 30));
          break;
      }
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Raporlar'),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt_outlined),
            onSelected: _onFilterChanged,
            itemBuilder: (BuildContext context) {
              return {'Son 7 Gün', 'Son 1 Ay', 'Son 3 Ay'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
            itemCount: _mealReports.length,
            itemBuilder: (context, index) {
              final mealReport = _mealReports[index];
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportDetailPage(mealReport: mealReport),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(mealReport.dateTime))),
                      subtitle: Text('Bolus Değeri: ${mealReport.bolus.bolusValue}'),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

