import 'package:colyak/models/fetchImage.dart';
import 'package:colyak/utils/colors.dart';
import 'package:colyak/views/screens/recipedetailpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colyak/models/auth_model.dart';
import 'package:colyak/models/service/api_service.dart';
import 'package:colyak/models/recipejson.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Receipt> top5Receipts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTop5Receipts();
  }

  Future<void> _fetchTop5Receipts() async {
    try {
      final authModel = Provider.of<AuthModel>(context, listen: false);
      final apiService = ApiService();
      final imageService = ImageService(); // Declare imageService here
      final receipts = await apiService.getTop5Receipts(authModel.token!);
      List<Receipt> receiptsWithImages = [];
      for (var receipt in receipts) {
        if (receipt.imageId != null) {
          String imageURI =
              "https://api.colyakdiyabet.com.tr/api/image/get/${receipt.imageId}";
          receipt.imageUrl = imageURI;
          receipt.imageBytes = await imageService.getImageBytes(imageURI);
        }
        receiptsWithImages.add(receipt);
      }
      setState(() {
        top5Receipts = receiptsWithImages;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching top 5 receipts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<AuthModel>(context).userName;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Center(
          child: Text('Çölyak'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (userName != null)
                          Center(
                            child: Text(
                              'Merhaba, $userName!',
                              style: const TextStyle(
                                  fontFamily: 'NotoSans', fontSize: 20),
                            ),
                          ),
                        const SizedBox(height: 16.0),
                        const Center(
                            child: Text(
                              'En Çok Beğenilen 5 Tarife Gözat',
                              style: TextStyle(
                                  fontFamily: 'NotoSans', fontSize: 20),
                            ),
                          ),
                        const Divider(thickness: 1.0, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final receipt = top5Receipts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(receipt: receipt!),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              receipt.imageBytes != null
                                  ? Image.memory(receipt.imageBytes!)
                                  : Container(),
                              ListTile(
                                title: Text(receipt.receiptName ?? 'No name'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: top5Receipts.length,
                  ),
                ),
              ],
            ),
    );
  }
}
