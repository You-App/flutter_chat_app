import 'dart:convert';
import 'package:chat_app/models/chat/chat_list_model.dart';
import 'package:chat_app/models/chat/conversation_model.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class ConversationProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMsg = '';
  ConversationModel _res;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMsg => _errorMsg ?? '';
  ConversationModel get res => _res;

  Future<void> getChatDetail(String room) async {
    print('a');
    this.setError = false;
    this.setLoading = true;
    try {
      await dio.post('/chat/detail', data: {"offset": 0, "room": '$room'}).then((res) {
        _res = ConversationModel.fromJson(res.data is String ? jsonDecode(res.data) : res.data);
        notifyListeners();
      });
    } catch (e) {
      this.setError = true;
      this.setErrorMsg = '$e';
    }
    this.setLoading = false;
  }

  set setLoading(bool val) {
    if (val == _isLoading) return;
    _isLoading = val;
    notifyListeners();
  }

  set setError(bool val) {
    if (val == _hasError) return;
    _hasError = val;
    notifyListeners();
  }

  set setErrorMsg(String val) {
    _errorMsg = val;
    notifyListeners();
  }
}
