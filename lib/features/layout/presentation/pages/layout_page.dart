import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/presentation/pages/download_page.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_states.dart';
import 'package:tamadrop/features/themes/theme_cubit.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final layoutCubit = context.read<LayoutCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tama Drop'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSwitch(
              value: themeCubit.isDarkMode,
              onChanged: (value) {
                themeCubit.toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<LayoutCubit, LayoutState>(
                    builder: (context, state) {
                      return layoutCubit.page;
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Scaffold(
                        body: BlocListener<LayoutCubit, LayoutState>(
                          listener: (context, state) {
                            if (state is LayoutError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                ),
                              );
                            }
                          },
                          child: const DownloadPage(),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.download),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
