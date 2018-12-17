import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement{

      storeNewUser(user, context){
        try {

          Firestore.instance.collection('/user').add({
            'name': user.name,
            'uid': user.id,
            'phone': user.phone,
            'password': user.password
          });
        }catch(error){
          print(error.message);
        }
      }
}