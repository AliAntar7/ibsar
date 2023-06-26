import 'package:ebsar2/core/constants/app_string.dart';
import 'package:ebsar2/features/category/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = CategoryCubit.get(context);
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: cubit.isListening
              ? () {
                  print('double tap');
                }
              : null,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                elevation: 1,
                title: const Text(
                  AppString.categories,
                ),
              ),
              body: Container(
                color: Colors.grey[300],
                child: GridView.count(
                  //shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 5.0,
                  padding: const EdgeInsets.all(5.0),
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 1 / 1.30,
                  children: List.generate(
                    cubit.categoriesNames.length,
                        (index) => Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  '${cubit.categoriesImages[index]}',
                                  //fit: BoxFit.cover,
                                  width: 150,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  cubit.categoriesNames[index],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}