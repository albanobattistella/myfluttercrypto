import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfluttercrypto/data/result_data.dart';
import 'package:myfluttercrypto/screens/result_screen.dart';
import 'package:myfluttercrypto/screens/settings_screen.dart';
import 'package:myfluttercrypto/utils/constant_util.dart';
import 'package:myfluttercrypto/utils/crypto_util.dart';
import 'package:myfluttercrypto/utils/enum_util.dart';
import 'package:myfluttercrypto/utils/wdg_util.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerTxtInput = TextEditingController();
    CryptoUtil _cryptoUtil = CryptoUtil();

    void _goToSettings() {
      WdgUtil.goToScreen(context: context, screen: const SettingsScreen());
    }

    void _goToAbout() {
      WdgUtil.goToScreen(context: context, screen: const AboutScreen());
    }

    bool _valTxtIsEmpty() {
      if (_controllerTxtInput.text.isEmpty) {
        WdgUtil.buildDialog(
            context, TypeDialog.error, ConstantUtil.errTxtIsEmpty);
        return false;
      }
      return true;
    }

    void _encryptText() {
      if (!_valTxtIsEmpty()) {
        return;
      }

      WdgUtil.goToScreen(
          context: context,
          screen: ResultScreen(ConstantUtil.titleEncrypt,
              _cryptoUtil.txtEncrypt(_controllerTxtInput.text)));
    }

    void _decryptText() {
      if (!_valTxtIsEmpty()) {
        return;
      }

      ResultData resultData = _cryptoUtil.txtDecrypt(_controllerTxtInput.text);
      if (resultData.resultHasError()) {
        WdgUtil.buildDialog(
            context, TypeDialog.error, ConstantUtil.errDecryptTxt);
        return;
      }

      WdgUtil.goToScreen(
          context: context,
          screen:
              ResultScreen(ConstantUtil.titleDecrypt, resultData.resultTxt()));
    }

    void _clearInputText() {
      setState(() {
        _controllerTxtInput.text = '';
      });
    }

    Row _rowTxtInfoInput = WdgUtil.buildRow(RichText(
        textAlign: TextAlign.center,
        textScaleFactor: 1.2,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: ConstantUtil.inputYourText,
              style: TextStyle(
                  height: ConstantUtil.lineHeightDefault,
                  color: ConstantUtil.colorTxtDefault))
        ])));

    Flexible _flexInputTxt = Flexible(
        child: Container(
            constraints:
                const BoxConstraints(maxWidth: ConstantUtil.maxWidthBox),
            padding: const EdgeInsets.only(top: ConstantUtil.defaultPadTop),
            child: TextField(
              controller: _controllerTxtInput,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              textAlign: TextAlign.center,
              minLines: 8,
              maxLines: 16,
              toolbarOptions: const ToolbarOptions(
                  copy: false, selectAll: false, paste: true),
            )));

    Row _rowTxtBtns = WdgUtil.buildRow(ButtonBar(
        buttonPadding: const EdgeInsets.all(16),
        overflowButtonSpacing: 16,
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          WdgUtil.buildTxtButton(
              context, ConstantUtil.txtEncrypt, _encryptText),
          WdgUtil.buildTxtButton(
              context, ConstantUtil.clearTxt, _clearInputText,
              bkgColorBtn: ConstantUtil.colorSilver),
          WdgUtil.buildTxtButton(context, ConstantUtil.txtDecrypt, _decryptText,
              bkgColorBtn: ConstantUtil.colorAlert,
              txtColorBtn: ConstantUtil.colorTxtDefault)
        ]));

    AppBar _buildAppBar = AppBar(
        backgroundColor: ConstantUtil.colorThemeApp,
        title: const Text(ConstantUtil.nmApplication),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              tooltip: ConstantUtil.settings,
              onPressed: _goToSettings),
          IconButton(
              icon: const Icon(Icons.info),
              tooltip: ConstantUtil.about,
              onPressed: _goToAbout)
        ]);

    return WdgUtil.buildScaffold(
        context, _buildAppBar, [_rowTxtInfoInput, _flexInputTxt, _rowTxtBtns]);
  }
}
