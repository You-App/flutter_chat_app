import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket kSocket;
PublishSubject messageStream = PublishSubject();
PublishSubject activeUserStream = PublishSubject();

class IOSystem {
  void init({@required String uuid}) {
    if (kSocket == null) {
      kSocket = IO.io('http://192.168.10.71:3000/', <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'query': 'uuid=$uuid'
      });
    }
  }

  void connectSocket({@required String uuid}) {
    kSocket?.disconnect();
    init(uuid: uuid);
    kSocket.connect();
    try {
      kSocket.on('connect', (data) {
        print('qweqwe');
        kSocket.emit('register', {"uuid": "$uuid"});

        kSocket.on('receive_msg', (data) {
          messageStream.add(data);
        });

        kSocket.on('active_users', (data) {
          activeUserStream.add(data);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void sendMsg({String msg, String receiver}) {
    kSocket.emit('send_msg',
        {"to": receiver, "message": msg, "onCreate": '${DateTime.now()}'});
  }

  void disconnectSocket() async {
    try {
      kSocket.disconnect();
      print('SOCKET DISCONNECTED');
    } catch (e) {
      print(e);
    }
  }
}
