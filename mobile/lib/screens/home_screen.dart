import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/analysis_response.dart';
import '../services/api_service.dart';
import '../widgets/arcade_button.dart';
import '../widgets/arcade_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final ApiService _apiService = ApiService();

  final List<File> _images = [];

  AnalysisResponse? _result;

  bool _isAnalyzing = false;
  String? _errorMessage;

  Future<void> _showImageSourcePicker() async {
    if (_images.length >= 3) {
      _showMessage('Maximum of 3 images allowed.');
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SELECT INPUT',
                  style: AppTypography.arcade(
                    fontSize: 14,
                    color: AppColors.neonGreen,
                  ),
                ),
                const SizedBox(height: 24),
                ArcadeButton(
                  label: 'CAMERA',
                  icon: Icons.camera_alt_outlined,
                  onPressed: () {
                    Navigator.pop(context);
                    _pickFromCamera();
                  },
                ),
                const SizedBox(height: 12),
                ArcadeButton(
                  label: 'GALLERY',
                  icon: Icons.photo_library_outlined,
                  onPressed: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image == null) return;

      setState(() {
        _images.add(File(image.path));
        _result = null;
        _errorMessage = null;
      });
    } catch (error) {
      _showMessage('Unable to access the camera.');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final selectedImages = await _imagePicker.pickMultiImage(
        imageQuality: 90,
      );

      if (selectedImages.isEmpty) return;

      final remainingSlots = 3 - _images.length;

      setState(() {
        _images.addAll(
          selectedImages
              .take(remainingSlots)
              .map((image) => File(image.path)),
        );

        _result = null;
        _errorMessage = null;
      });

      if (selectedImages.length > remainingSlots) {
        _showMessage('Only 3 images can be analyzed at once.');
      }
    } catch (error) {
      _showMessage('Unable to access the gallery.');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      _result = null;
      _errorMessage = null;
    });
  }

  Future<void> _analyze() async {
    if (_images.isEmpty || _isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
      _result = null;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.analyzeImages(_images);

      if (!mounted) return;

      setState(() {
        _result = result;
        _isAnalyzing = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isAnalyzing = false;
        _errorMessage = _friendlyError(error);
      });
    }
  }

  String _friendlyError(Object error) {
    if (error is ApiException) {
      if (error.statusCode >= 500) {
        return 'The scanner is temporarily unavailable.\nPlease try again.';
      }

      return error.message;
    }

    return 'Something went wrong.\nPlease try again.';
  }

  void _reset() {
    setState(() {
      _images.clear();
      _result = null;
      _errorMessage = null;
      _isAnalyzing = false;
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.bodySecondary,
        ),
        backgroundColor: AppColors.surfaceLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    children: [
      TextSpan(
        text: 'सार',
        style: AppTypography.devanagariArcade(
          fontSize: 35,
          color: AppColors.neonGreen,
        ),
      ),
      TextSpan(
        text: 'AI',
        style: AppTypography.arcade(
          fontSize: 22,
          color: AppColors.neonGreen,
        ),
      ),
    ],
  ),
),
        const SizedBox(height: 10),
        Text(
          'FOOD SCANNER',
          textAlign: TextAlign.center,
          style: AppTypography.arcade(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 2,
          color: AppColors.neonGreen,
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (_result != null) {
      return _buildResult();
    }

    if (_isAnalyzing) {
      return _buildAnalyzing();
    }

    return _buildScanner();
  }

  Widget _buildScanner() {
    return Column(
      children: [
        ArcadePanel(
          child: Column(
            children: [
              Text(
                'READY PLAYER 1',
                style: AppTypography.arcade(
                  fontSize: 12,
                  color: AppColors.yellow,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'SCAN YOUR FOOD',
                style: AppTypography.arcade(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'UPLOAD 1–3 IMAGES OF A FOOD PRODUCT',
                textAlign: TextAlign.center,
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 28),
              ArcadeButton(
                label: 'ADD IMAGES',
                icon: Icons.add_a_photo_outlined,
                onPressed: _showImageSourcePicker,
              ),
            ],
          ),
        ),
        if (_images.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildImagePreview(),
          const SizedBox(height: 18),
          ArcadeButton(
            label: 'ANALYZE FOOD',
            icon: Icons.bolt,
            onPressed: _analyze,
          ),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: 18),
          _buildError(),
        ],
      ],
    );
  }

  Widget _buildImagePreview() {
    return ArcadePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'IMAGES',
                style: AppTypography.arcade(
                  fontSize: 10,
                  color: AppColors.cyan,
                ),
              ),
              const Spacer(),
              Text(
                '${_images.length}/3',
                style: AppTypography.arcade(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 105,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Image.file(
                        _images[index],
                        width: 105,
                        height: 105,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          color: AppColors.black,
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzing() {
    return ArcadePanel(
      padding: const EdgeInsets.symmetric(
        vertical: 48,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Text(
            'SCANNING...',
            style: AppTypography.arcade(
              fontSize: 18,
              color: AppColors.neonGreen,
            ),
          ),
          const SizedBox(height: 30),
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppColors.neonGreen,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'ANALYZING FOOD DATA',
            textAlign: TextAlign.center,
            style: AppTypography.arcade(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'PLEASE WAIT...',
            style: AppTypography.arcade(
              fontSize: 9,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return ArcadePanel(
      child: Column(
        children: [
          Text(
            'SCAN ERROR',
            style: AppTypography.arcade(
              fontSize: 12,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: AppTypography.bodySecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
  final result = _result!;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // ─────────────────────────────────────────────
      // SCORECARD — SINGLE HUD UNIT
      // ─────────────────────────────────────────────

      _buildScoreCard(result),

      // ─────────────────────────────────────────────
      // OTHER RESULT SECTIONS
      // ─────────────────────────────────────────────

      if (result.positiveFactors.isNotEmpty)
        _buildListSection(
          'POSITIVE FACTORS',
          result.positiveFactors,
          AppColors.neonGreen,
        ),

      if (result.negativeFactors.isNotEmpty)
        _buildListSection(
          'NEGATIVE FACTORS',
          result.negativeFactors,
          AppColors.red,
        ),

      if (result.scoreFactors.isNotEmpty)
        _buildListSection(
          'SCORE FACTORS',
          result.scoreFactors,
          AppColors.orange,
        ),

      if (result.allergens.isNotEmpty)
        _buildListSection(
          'ALLERGENS',
          result.allergens,
          AppColors.red,
        ),

      if (result.ingredients.isNotEmpty)
        _buildIngredientsSection(result.ingredients),

      _buildResultSection(
        'CONFIDENCE',
        result.confidence.toUpperCase(),
        AppColors.cyan,
      ),

      if (result.missingInformation.isNotEmpty)
        _buildListSection(
          'MISSING INFORMATION',
          result.missingInformation,
          AppColors.yellow,
        ),

      const SizedBox(height: 20),

      ArcadeButton(
        label: 'SCAN ANOTHER',
        icon: Icons.refresh,
        onPressed: _reset,
        outlined: true,
      ),
    ],
  );
}

  Widget _buildScoreCard(AnalysisResponse result) {
  final scoreColor = _scoreColor(result.healthScore);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(
      14,
      26,
      14,
      18,
    ),
    decoration: BoxDecoration(
      color: AppColors.backgroundDeep,
      border: Border.all(
        color: AppColors.borderBright,
        width: 2,
      ),
      boxShadow: const [
        BoxShadow(
          color: AppColors.black,
          offset: Offset(5, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        // ─────────────────────────────────────────
        // FINAL SCORE
        // ─────────────────────────────────────────

        Text(
          'FINAL SCORE',
          textAlign: TextAlign.center,
          style: AppTypography.arcade(
            fontSize: 22,
            color: AppColors.cyan,
          ),
        ),

        const SizedBox(height: 20),

        // ─────────────────────────────────────────
        // DOTTED DIVIDER
        // ─────────────────────────────────────────

        _buildScoreDottedDivider(),

        const SizedBox(height: 18),

        // ─────────────────────────────────────────
        // PRODUCT + BRAND
        // ─────────────────────────────────────────

        _buildScoreHudPanel(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          child: Row(
  children: [
    Expanded(
  flex: 8,
  child: Text(
    result.productName ?? 'UNKNOWN PRODUCT',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: AppTypography.arcade(
      fontSize: 19,
      color: AppColors.textPrimary,
    ),
  ),
),

    const SizedBox(width: 8),

    Container(
      width: 2,
      height: 36,
      color: AppColors.borderBright,
    ),

    const SizedBox(width: 8),

    SizedBox(
  width: 75,
  child: Text(
    result.brand ?? 'UNKNOWN BRAND',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: AppTypography.bodySecondary.copyWith(
      fontSize: 15,
      color: AppColors.textSecondary,
    ),
  ),
),
  ],
),
        ),

        const SizedBox(height: 14),

        // ─────────────────────────────────────────
        // SCORE + RATING
        // ─────────────────────────────────────────

        _buildScoreHudPanel(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          child: Row(
  children: [
    Expanded(
      flex: 6,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _buildScoreValue(result),
        ),
      ),
    ),

    Container(
      width: 2,
      height: 52,
      color: AppColors.borderBright,
    ),

    Expanded(
      flex: 4,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            result.rating.toUpperCase(),
            style: AppTypography.arcade(
              fontSize: 13,
              color: scoreColor,
            ),
          ),
        ),
      ),
    ),
  ],
),
        ),

        const SizedBox(height: 14),

        // ─────────────────────────────────────────
        // PROGRESS BAR
        // ─────────────────────────────────────────

        if (result.healthScore != null)
          _buildScoreHudPanel(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.black,
                border: Border.all(
                  color: AppColors.border,
                  width: 2,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: result.healthScore! / 100,
                  child: Container(
                    color: scoreColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

  Widget _buildScoreHudPanel({
  required Widget child,
  EdgeInsetsGeometry padding = const EdgeInsets.all(16),
}) {
  return Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.backgroundDeep,
      border: Border.all(
        color: AppColors.borderBright,
        width: 2,
      ),
      boxShadow: const [
        BoxShadow(
          color: AppColors.black,
          offset: Offset(3, 3),
        ),
      ],
    ),
    child: child,
  );
}

  Widget _buildScoreDottedDivider() {
  return SizedBox(
    height: 6,
    child: Row(
      children: List.generate(
        35,
        (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                height: 3,
                color: index % 4 == 0
                    ? AppColors.borderBright
                    : AppColors.border,
              ),
            ),
          );
        },
      ),
    ),
  );
}

  Widget _buildScoreValue(AnalysisResponse result) {
  final score = result.healthScore;

  if (score == null) {
    return Text(
      'N/A',
      style: AppTypography.arcade(
        fontSize: 20,
        color: AppColors.textSecondary,
      ),
    );
  }

  final scoreColor = _scoreColor(score);

  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      Text(
        '$score',
        style: AppTypography.arcade(
          fontSize: 38,
          color: scoreColor,
        ),
      ),
      const SizedBox(width: 7),
      Text(
        '/100',
        style: AppTypography.arcade(
          fontSize: 14,
          color: scoreColor,
        ),
      ),
    ],
  );
}

  Color _scoreColor(int? score) {
    if (score == null) return AppColors.textSecondary;

    if (score >= 75) return AppColors.neonGreen;
    if (score >= 60) return AppColors.yellow;
    if (score >= 40) return AppColors.orange;

    return AppColors.red;
  }

  Widget _buildResultSection(
    String title,
    String content,
    Color accent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: ArcadePanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.arcade(
                fontSize: 10,
                color: accent,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: AppTypography.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection(
    String title,
    List<String> items,
    Color accent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: ArcadePanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.arcade(
                fontSize: 10,
                color: accent,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '>',
                      style: AppTypography.arcade(
                        fontSize: 10,
                        color: accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsSection(List<String> ingredients) {
  final midpoint = (ingredients.length / 2).ceil();

  final leftColumn = ingredients.sublist(0, midpoint);
  final rightColumn = ingredients.sublist(midpoint);

  Widget buildColumn(List<String> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map(
          (item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '>',
                    style: AppTypography.arcade(
                      fontSize: 9,
                      color: AppColors.cyan,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTypography.body,
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.only(top: 14),
    child: ArcadePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INGREDIENTS',
            style: AppTypography.arcade(
              fontSize: 10,
              color: AppColors.cyan,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumn(leftColumn),
              const SizedBox(width: 12),
              buildColumn(rightColumn),
            ],
          ),
        ],
      ),
    ),
  );
}
}