import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/product_detail_provider.dart';
import '../widgets/product_detail_content.dart';

class ProductDetailPage extends StatefulWidget {
  final String shareUrl;
  final bool isPersonal;

  const ProductDetailPage({
    super.key,
    required this.shareUrl,
    this.isPersonal = false,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailProvider>().getProductDetail(widget.shareUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Consumer<ProductDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading product details...'),
            );
          }

          final result = provider.productDetailResult;
          if (result == null) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (result.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    result.errorMessage ?? 'Something went wrong',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.getProductDetail(widget.shareUrl),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ProductDetailContent(
            product: provider.productDetail!,
            isPersonal: widget.isPersonal,
          );
        },
      ),
    );
  }
}
