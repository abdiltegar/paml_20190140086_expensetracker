import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paml_20190140086_ewallet/domain/helpers/date_formatter.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/report/report_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/transaction/transaction_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/user/user_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutcomeRepository {
  final TransactionInteractor transactionInteractor = TransactionInteractor();
  final ReportInteractor reportInteractor = ReportInteractor();
  final UserInteractor userInteractor = UserInteractor();

  Future<List<TransactionModel>> get () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return transactionInteractor.getByIsIncome(prefs.getString('uid')!, false);
  }

  Future add(TransactionModel payload) async {
    DateFormatter dateFormatter = DateFormatter();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = TransactionModel(
      id: "", 
      userId: prefs.getString('uid')!, 
      amount: payload.amount, 
      isIncome: payload.isIncome, 
      trxDate: payload.trxDate, 
      description: payload.description
    );

    debugPrint("data incom to be send to interactor");

    final newOutcome = <String, dynamic>{
      'user_id': data.userId,
      'amount': data.amount,
      'description': data.description,
      'is_income': data.isIncome,
      'trx_date': data.trxDate
    };

    // Update || Add daily report's amount
    
    var dailyReport = await reportInteractor.getByDate(data.userId, dateFormatter.dateFormatYMD(data.trxDate));
    if(dailyReport != null){ // if report at data.date is not empty , update the amount
      int updatedAmount = data.isIncome ? dailyReport.amount + data.amount : dailyReport.amount - data.amount;

      var updatedReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': updatedAmount
      };

      await reportInteractor.update(dailyReport.id, updatedReport);
    } else {// if report at data.date is empty , add new report

      var newReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': data.amount
      };

      await reportInteractor.add(newReport);
    }

    // Update user's balance
    var user = await userInteractor.get(prefs.getString('uid')!, prefs.getString('email')!);
    if(user != null){
      int balance = data.isIncome ? user.balance + data.amount : user.balance - data.amount;
      var updatedUser = <String, dynamic>{
        'id': user.id, 
        'uid': user.uid, 
        'name': user.name, 
        'email': user.email, 
        'balance': balance
      };

      await userInteractor.update(user.id, updatedUser);
    }

    return await transactionInteractor.add(newOutcome);
  }

  Future edit(TransactionModel data) async {
    DateFormatter dateFormatter = DateFormatter();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final updatedOutcome = <String, dynamic>{
      'user_id': data.userId,
      'amount': data.amount,
      'description': data.description,
      'is_income': data.isIncome,
      'trx_date': data.trxDate
    };

    var prevOutcome = await transactionInteractor.getById(data.id);
    if(prevOutcome == null){
      return false;
    }

    var dailyReport = await reportInteractor.getByDate(data.userId, dateFormatter.dateFormatYMD(data.trxDate));
    if(dailyReport != null){ // if report at data.date is not empty , update the amount
      int updatedAmount = data.isIncome ? (dailyReport.amount - prevOutcome.amount) + data.amount : (dailyReport.amount - prevOutcome.amount) - data.amount;

      var updatedReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': updatedAmount
      };

      await reportInteractor.update(dailyReport.id, updatedReport);
    } else {// if report at data.date is empty , add new report

      var newReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': data.amount
      };

      await reportInteractor.add(newReport);
    }

    // Update user's balance
    var user = await userInteractor.get(prefs.getString('uid')!, prefs.getString('email')!);
    if(user != null){
      int balance = data.isIncome ? (data.amount - prevOutcome.amount) + data.amount : (data.amount - prevOutcome.amount) - data.amount;
      var updatedUser = <String, dynamic>{
        'id': user.id, 
        'uid': user.uid, 
        'name': user.name, 
        'email': user.email, 
        'balance': balance
      };

      await userInteractor.update(user.id, updatedUser);
    }
    
    return await transactionInteractor.update(data.id,updatedOutcome);
  }

  Future delete(String id) async {
    DateFormatter dateFormatter = DateFormatter();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = await transactionInteractor.getById(id);
    if(data == null){
      return false;
    }

    var dailyReport = await reportInteractor.getByDate(data.userId, dateFormatter.dateFormatYMD(data.trxDate));
    if(dailyReport != null){ // if report at data.date is not empty , update the amount
      int updatedAmount = data.isIncome ? dailyReport.amount - data.amount : dailyReport.amount +  data.amount;

      var updatedReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': updatedAmount
      };

      await reportInteractor.update(dailyReport.id, updatedReport);
    }

    // Update user's balance
    var user = await userInteractor.get(prefs.getString('uid')!, prefs.getString('email')!);
    if(user != null){
      int balance = data.isIncome ? user.balance - data.amount : user.balance +  data.amount;
      var updatedUser = <String, dynamic>{
        'id': user.id, 
        'uid': user.uid, 
        'name': user.name, 
        'email': user.email, 
        'balance': balance
      };

      await userInteractor.update(user.id, updatedUser);
    }
    
    return await transactionInteractor.delete(data.id);
  }
}