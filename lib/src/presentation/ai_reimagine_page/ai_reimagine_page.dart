// lib/screens/ai_reimagine_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stepback/src/presentation/ai_reimagine_page/ai_reimagine_cubit.dart';

class AIReimaginePage extends StatefulWidget {
  static const String routeName = '/ai-reimagine';
  const AIReimaginePage({Key? key}) : super(key: key);

  @override
  _AIReimaginePageState createState() => _AIReimaginePageState();
}

class _AIReimaginePageState extends State<AIReimaginePage> {
  int _selectedYear = 1900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Re-imagine'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocProvider(
        create: (context) => AIReimagineCubit(),
        child: BlocConsumer<AIReimagineCubit, AIReimagineState>(
          listener: (context, state) {
            if (state is AIReimagineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (state is AIReimagineTransformed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Image transformed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Text(
                    'Transform Historical Sites',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Year Selection Section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select a Year:',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '1800',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Expanded(
                                child: Slider(
                                  value: _selectedYear.toDouble(),
                                  min: 1800,
                                  max: 2000,
                                  divisions: 200,
                                  label: '$_selectedYear',
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (double value) {
                                    setState(() {
                                      _selectedYear = value.toInt();
                                    });
                                    context
                                        .read<AIReimagineCubit>()
                                        .selectYear(_selectedYear);
                                  },
                                ),
                              ),
                              Text(
                                '2000',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Center(
                            child: Text(
                              'Selected Year: $_selectedYear',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Action Button Section
                  _buildActionButton(context, state),
                  SizedBox(height: 20),

                  // Display Captured Image Before Transformation
                  if (state is AIReimagineImageCaptured ||
                      state is AIReimagineTransforming ||
                      state is AIReimagineTransformed)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Captured Image',
                              style:
                                  Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                            SizedBox(height: 10),
                            Image.file(
                              context.read<AIReimagineCubit>().capturedImage!,
                              fit: BoxFit.cover,
                              // loadingBuilder: (context, child, progress) {
                              //   if (progress == null) return child;
                              //   return Center(
                              //     child: CircularProgressIndicator(
                              //       value: progress.expectedTotalBytes != null
                              //           ? progress.cumulativeBytesLoaded /
                              //               progress.expectedTotalBytes!
                              //           : null,
                              //     ),
                              //   );
                              // },
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  'Failed to load image.',
                                  style: TextStyle(color: Colors.red),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 20),

                  // Transformed Image Section
                  if (state is AIReimagineTransformed)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Transformed Image',
                              style:
                                  Theme.of(context).textTheme.displayMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                            SizedBox(height: 10),
                            CachedNetworkImage(
                              imageUrl: state.imageUrl,
                              fit: BoxFit.cover,
                              // loadingBuilder: (context, child, progress) {
                              //   if (progress == null) return child;
                              //   return Center(
                              //     child: CircularProgressIndicator(
                              //       value: progress.expectedTotalBytes != null
                              //           ? progress.cumulativeBytesLoaded /
                              //               progress.expectedTotalBytes!
                              //           : null,
                              //     ),
                              //   );
                              // },
                              errorWidget: (context, error, stackTrace) {
                                return Text(
                                  'Failed to load image.',
                                  style: TextStyle(color: Colors.red),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 20),

                  // Loading Indicator for Transformation
                  if (state is AIReimagineCapturing ||
                      state is AIReimagineTransforming)
                    Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, AIReimagineState state) {
    String buttonText = 'Capture Image';
    VoidCallback? onPressed;

    if (state is AIReimagineInitial || state is AIReimagineYearSelected) {
      buttonText = 'Capture Image';
      onPressed = () {
        context.read<AIReimagineCubit>().captureImage();
      };
    } else if (state is AIReimagineImageCaptured) {
      buttonText = 'Transform Image';
      onPressed = () {
        context.read<AIReimagineCubit>().transformImage();
      };
    } else if (state is AIReimagineTransformed) {
      buttonText = 'Try Again';
      onPressed = () {
        context.read<AIReimagineCubit>().reset();
      };
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
