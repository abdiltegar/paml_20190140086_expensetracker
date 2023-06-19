// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';

class ReportViewModel {
  late final List<ReportModel> dailyReports;
  late final List<TransactionModel> transactions;
  late final int maxIncome;
  late final int maxOutcome;
  late final int totalIncome;
  late final int totalOutcome;
  ReportViewModel({
    required this.dailyReports,
    required this.transactions,
    required this.maxIncome,
    required this.maxOutcome,
    required this.totalIncome,
    required this.totalOutcome,
  });

  ReportViewModel copyWith({
    List<ReportModel>? dailyReports,
    List<TransactionModel>? transactions,
    int? maxIncome,
    int? maxOutcome,
    int? totalIncome,
    int? totalOutcome,
  }) {
    return ReportViewModel(
      dailyReports: dailyReports ?? this.dailyReports,
      transactions: transactions ?? this.transactions,
      maxIncome: maxIncome ?? this.maxIncome,
      maxOutcome: maxOutcome ?? this.maxOutcome,
      totalIncome: totalIncome ?? this.totalIncome,
      totalOutcome: totalOutcome ?? this.totalOutcome,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dailyReports': dailyReports.map((x) => x.toMap()).toList(),
      'transactions': transactions.map((x) => x.toMap()).toList(),
      'maxIncome': maxIncome,
      'maxOutcome': maxOutcome,
      'totalIncome': totalIncome,
      'totalOutcome': totalOutcome,
    };
  }

  factory ReportViewModel.fromMap(Map<String, dynamic> map) {
    return ReportViewModel(
      dailyReports: List<ReportModel>.from((map['dailyReports'] as List<int>).map<ReportModel>((x) => ReportModel.fromMap(x as Map<String,dynamic>),),),
      transactions: List<TransactionModel>.from((map['transactions'] as List<int>).map<TransactionModel>((x) => TransactionModel.fromMap(x as Map<String,dynamic>),),),
      maxIncome: map['maxIncome'] as int,
      maxOutcome: map['maxOutcome'] as int,
      totalIncome: map['totalIncome'] as int,
      totalOutcome: map['totalOutcome'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportViewModel.fromJson(String source) => ReportViewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReportViewModel(dailyReports: $dailyReports, transactions: $transactions, maxIncome: $maxIncome, maxOutcome: $maxOutcome, totalIncome: $totalIncome, totalOutcome: $totalOutcome)';
  }

  @override
  bool operator ==(covariant ReportViewModel other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.dailyReports, dailyReports) &&
      listEquals(other.transactions, transactions) &&
      other.maxIncome == maxIncome &&
      other.maxOutcome == maxOutcome &&
      other.totalIncome == totalIncome &&
      other.totalOutcome == totalOutcome;
  }

  @override
  int get hashCode {
    return dailyReports.hashCode ^
      transactions.hashCode ^
      maxIncome.hashCode ^
      maxOutcome.hashCode ^
      totalIncome.hashCode ^
      totalOutcome.hashCode;
  }
}
