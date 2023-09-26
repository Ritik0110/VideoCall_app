import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRoleType _role = ClientRoleType.clientRoleBroadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agora"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.network("https://tinyurl.com/2p889y4k"),
              const SizedBox(height: 20),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  labelText: 'Channel Name',
                  errorText:
                      _validateError ? 'Channel name is mandatory' : null,
                ),
              ),
              RadioListTile<ClientRoleType>(
                  value: ClientRoleType.clientRoleBroadcaster,
                  groupValue: _role,
                  onChanged: (ClientRoleType? value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                  title: const Text("Broadcaster")),
              RadioListTile<ClientRoleType>(
                  value: ClientRoleType.clientRoleAudience,
                  groupValue: _role,
                  onChanged: (ClientRoleType? value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                  title: const Text("Audience")),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: onJoin,
                height: 40,
                minWidth: double.infinity,
                child: const Text("Join"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      await _handlePermissions(Permission.camera);
      await _handlePermissions(Permission.microphone);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallPage(
                    channelName: _channelController.text,
                    clientRole: _role,
                  )));
    }
  }
  Future<bool> _handlePermissions(Permission permission) async{
    var check = await permission.status;
    if(check.isDenied){
      await permission.request();
      print(permission.status);
      return (await permission.status).isGranted;
  }
    return (await permission.status).isGranted;
}
}
