import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'images/keep_simple_business_records.png',
    title: 'Keep Simple Business Record',
    description: 'Keep Your Transaction right here from your phone n/ Send Invoices  and set reminders  of installment payments.',
  ),
  Slide(
    imageUrl: 'images/income_expense.png',
    title: 'Income & Expenses',
    description: 'Track Your Cash  and  credits sales, and record  your  n/ business expense. ',
  ),
  Slide(
    imageUrl: 'images/generate_business_data.png',
    title: 'Generate Business Data',
    description: 'Download  performance report of your entire n/ business and,  or of individual customers',
  ),
];