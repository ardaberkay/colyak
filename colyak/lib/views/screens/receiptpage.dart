import 'package:colyak/utils/colors.dart';
import 'package:colyak/views/screens/recipedetailpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colyak/models/auth_model.dart';
import 'package:colyak/models/service/api_service.dart';
import 'package:colyak/models/recipejson.dart';
import 'package:colyak/models/fetchImage.dart'; // Import your imageService class

class AllReceiptsPage extends StatefulWidget {
  const AllReceiptsPage({super.key});

  @override
  _AllReceiptsPageState createState() => _AllReceiptsPageState();
}

class _AllReceiptsPageState extends State<AllReceiptsPage> {
  List<Receipt> allReceipts = [];
  List<Receipt> filteredReceipts = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchAllReceipts();
  }

  Future<void> _fetchAllReceipts() async {
    try {
      final authModel = Provider.of<AuthModel>(context, listen: false);
      final apiService = ApiService();
      final imageService = ImageService(); // Declare imageService here
      final receipts = await apiService.getAllReceipts(authModel.token!);
      List<Receipt> receiptsWithImages = [];
      for (var receipt in receipts) {
        if (receipt.imageId != null) {
          String imageURI = "https://api.colyakdiyabet.com.tr/api/image/get/${receipt.imageId}";
          receipt.imageUrl = imageURI;
          receipt.imageBytes = await imageService.getImageBytes(imageURI);
        }
        receiptsWithImages.add(receipt);
      }
      setState(() {
        allReceipts = receiptsWithImages;
        filteredReceipts = receiptsWithImages;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching all receipts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterReceipts(String query) {
    final filtered = allReceipts.where((receipt) {
      final nameLower = receipt.receiptName?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      searchQuery = query;
      filteredReceipts = filtered;
    });
  }

  String _getTimeDifference(String createdDate) {
    final createdDateTime = DateTime.parse(createdDate);
    final now = DateTime.now();
    final difference = now.difference(createdDateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years yıl önce';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ay önce';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? '1 gün önce' : '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 saat önce' : '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 dakika önce' : '${difference.inMinutes} dakika önce';
    } else {
      return 'Şimdi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Center(
          child: Text('Tüm Tarifler'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterReceipts,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredReceipts.length,
              itemBuilder: (context, index) {
                final receipt = filteredReceipts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(receipt: receipt),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        receipt.imageBytes != null
                            ? Image.memory(receipt.imageBytes!)
                            : Container(),
                        ListTile(
                          title: Text(receipt.receiptName ?? 'No name'),
                          subtitle: Text(_getTimeDifference(receipt.createdDate ?? '')),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
