import 'package:akount_books/AppState/actions/user_phone_contacts_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/user_phone_contact.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';


class FetchUserData {
  fetchContacts(context) async {
    final business = StoreProvider.of<AppState>(context);
    PermissionStatus permissionStatus = await _getPermission();
    List<UserPhoneContact> userContacts = [];
    if (permissionStatus == PermissionStatus.granted) {
      var contacts = await ContactsService.getContacts();
      contacts.forEach((contact){
        String phone = "";
        String email = "";
        String address = "";
        if(contact.phones.isNotEmpty) {
          phone = contact.phones.first.value;
        }else{
          phone = "";
        }
        if(contact.emails.isNotEmpty) {
          email = contact.emails.first.value;
        }else{
          phone = "";
        }
        if(contact.emails.isNotEmpty) {
          email = contact.emails.first.value;
        }else{
          phone = "";
        }

        if(contact.emails.isNotEmpty) {
          email = contact.emails.first.value;
        }else{
          phone = "";
        }
        UserPhoneContact userContact= new UserPhoneContact(contact.displayName, contact.familyName, email, phone, address, contact.avatar);
        userContacts.add(userContact);
      });
      business.dispatch(AddUserContacts(payload: userContacts));
    } else {
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to location data denied',
        details: null,
      );
    }
  }
  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }
}