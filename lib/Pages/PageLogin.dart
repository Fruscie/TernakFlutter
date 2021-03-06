import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'PageHome.dart';
import 'PageRegister.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

enum statusLogin { signIn, notSignIn }

class _PageLoginState extends State<PageLogin> {
  statusLogin _loginStatus = statusLogin.notSignIn;
  final _keyForm = GlobalKey<FormState>();
  String nUsername, nPassword;
// check ketika klik tombol login
  checkForm() {
    final form = _keyForm.currentState;
    if (form.validate()) {
      form.save();
      submitDataLogin();
    }
  }

// mengirim request dan menanggapinya
  submitDataLogin() async {
    final responseData =
        await http.post("http://192.168.0.39/flutter_server/login.php", body: {
      "username": nUsername,
      "password": nPassword,
    });
    final data = jsonDecode(responseData.body);
    int value = data['value'];
    String pesan = data['message'];
    print(data);
// get data respon
    String dataUsername = data['username'];
    String dataEmail = data['email'];
    String dataAlamat = data['alamat'];
    String dataSex = data['sex'];
    String dataFullname = data['full_name'];
    String dataTanggalDaftar = data['tgl_daftar'];
    String dataIdUser = data['id_user'];
    print('ini value $value');
// cek value 1 atau 0
    if (value == 1) {
      setState(() {
// set status loginnya sebagai login
        _loginStatus = statusLogin.signIn;
// simpan data ke share preferences
        saveDataPref(value, dataIdUser, dataUsername, dataEmail, dataAlamat,
            dataSex, dataFullname, dataTanggalDaftar);
      });
    } else if (value == 2) {
      print(pesan);
    } else {
      print(pesan);
    }
  }

// method untuk soimpan share pref
  saveDataPref(int value, String dIdUser, dUsername, dEmail, dAlamat, dSex,
      dFullName, dCreated) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setInt("value", value);
      sharedPreferences.setString("username", dUsername);
      sharedPreferences.setString("id_user", dIdUser);
      sharedPreferences.setString("email", dEmail);
      sharedPreferences.setString("alamat", dAlamat);
      sharedPreferences.setString("sex", dSex);
      sharedPreferences.setString("full_name", dFullName);
      sharedPreferences.setString("tgl_daftar", dCreated);
    });
  }

  ///
  /// method ini digunakan untuk mengecek apakah user sudah login atau
  ///belum
  /// jika sudah set valuenya
  ///
  getDataPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      int nvalue = sharedPreferences.getInt("value");
      _loginStatus = nvalue == 1 ? statusLogin.signIn : statusLogin.notSignIn;
    });
  }

  @override
  void initState() {
    getDataPref();
    super.initState();
  }

//method untuk sign out
  signOUt() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setInt("value", null);
      // sharedPreferences.commit();
      _loginStatus = statusLogin.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case statusLogin.notSignIn:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _keyForm,
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                    'Login Form',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                      color: Colors.brown,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    validator: (value) {
//cek kalau value nya kosong
                      if (value.isEmpty) {
                        return 'Please Input Username';
                      }
                      return null;
                    },
                    onSaved: (value) => nUsername = value,
                    decoration: InputDecoration(
                        hintText: 'Username',
                        labelText: 'Input Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Input Password';
                      }
                      return null;
                    },
                    onSaved: (value) => nPassword = value,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Input Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0),
                  child: MaterialButton(
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                    child: Text('Login'),
                    onPressed: () {
                      setState(() {
                        checkForm();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
                  child: MaterialButton(
                    textColor: Colors.blueGrey,
                    child: Text('Belum Punya Akun ? Silahkan Daftar'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageRegister()));
                    },
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case statusLogin.signIn:
        return PageHome(signOUt());
        break;
    }
  }
}
