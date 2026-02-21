import 'package:equatable/equatable.dart';

abstract class SwitchEvents {
  SwitchEvents();

  @override
  List<Object> get props=>[];  
}

class EnableNotification extends SwitchEvents{}
class DisableNotification extends SwitchEvents{}