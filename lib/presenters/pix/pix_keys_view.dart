import 'package:flutter/material.dart';
import 'package:foradacaixac/presenters/pix/pix_insert_new_key_view.dart';

import '../../database/pix_key_type.dart';
import '../../database/user.dart';
import '../../database/user_pix_key.dart';

class PixKeysView extends StatefulWidget {
  final User user;
  final List<UserPixKey> listUserPixKey;

  const PixKeysView({super.key, required this.user, required this.listUserPixKey});

  @override
  State<PixKeysView> createState() => _PixKeysViewState();
}

class _PixKeysViewState extends State<PixKeysView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        title: Text('Minhas Chaves', style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Visualizar minhas chaves
              _inkWellSeeMyPixKeys(),
              const Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              //Cadastrar uma chave
              _inkWellRegisterAPixKey(),
              const Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _inkWellPixKeyOption(EnumPixKeyType enumPixKeyType) {
    //Navigator.push(context,MaterialPageRoute(builder: (_) => AccountPage(user: widget.user,listUserAccount: widget.listUserAccount,)));

    Icon iconKeyType;
    Text textKeyType;

    switch (enumPixKeyType) {
      case EnumPixKeyType.cpf_cnpj:
        iconKeyType = const Icon(Icons.article_rounded);
        textKeyType = const Text('CPF');
        break;
      case EnumPixKeyType.chave_aleatoria:
        iconKeyType = const Icon(Icons.shield_rounded);
        textKeyType = const Text('Chave Aleatória');
        break;
      case EnumPixKeyType.telefone:
        iconKeyType = const Icon(Icons.settings_cell_rounded);
        textKeyType = const Text('Celular');
        break;
      case EnumPixKeyType.email:
        iconKeyType = const Icon(Icons.email_rounded);
        textKeyType = const Text('Email');
        break;
      case EnumPixKeyType.none:
        iconKeyType = const Icon(Icons.error_rounded);
        textKeyType = const Text('ERRO');
    }

    InkWell inkWell = InkWell(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(5)),
          Row(
            children: [iconKeyType, const Padding(padding: EdgeInsets.only(left: 10)), textKeyType],
          ),
          const Padding(padding: EdgeInsets.all(5)),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PixInsertNewKeyView(
                      user: widget.user,
                      enumPixKeyType: enumPixKeyType,
                    )));
      },
    );
    return inkWell;
  }

  bool userHasCPFCNPJPixKey() {
    bool hasCNPJCPFPixKey = false;

    for (UserPixKey userPixKey in widget.listUserPixKey) {
      if (userPixKey.idTypePixKey == EnumPixKeyType.cpf_cnpj.index) {
        hasCNPJCPFPixKey = true;
        break;
      }
    }

    return hasCNPJCPFPixKey;
  }

  InkWell _inkWellSeeMyPixKeys() {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.vpn_key_rounded),
                    const Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text('Visualizar minhas chaves', style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 12.0)),
            Text('Visualize suas chaves cadastradas', style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
      onTap: () async {
        setState(() {
          //Navigator.push(context,MaterialPageRoute(builder: (_) => AccountPage(user: widget.user,listUserAccount: widget.listUserAccount,)));
        });
      },
    );
  }

  InkWell _inkWellRegisterAPixKey() {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.add),
                    const Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text('Cadastrar uma chave', style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 12.0)),
            Text('Cadastre uma chave nova', style: Theme.of(context).textTheme.headline6),
            const Padding(padding: EdgeInsets.only(bottom: 5.0)),
          ],
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          builder: (context) {
            return FractionallySizedBox(
                heightFactor: 0.5,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: const Icon(
                                  Icons.clear_rounded,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Visibility(
                            visible: userHasCPFCNPJPixKey() ? false : true,
                            child: _inkWellPixKeyOption(EnumPixKeyType.cpf_cnpj),
                          ),
                          _inkWellPixKeyOption(EnumPixKeyType.telefone),
                          _inkWellPixKeyOption(EnumPixKeyType.email),
                          _inkWellPixKeyOption(EnumPixKeyType.chave_aleatoria),
                        ],
                      ),
                    )));
          },
        );
      },
    );
  }
}
