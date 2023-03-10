// ignore_for_file: file_names

import 'package:bloodDonate/blocks/BlocEventStateBase.dart';
import 'package:flutter/cupertino.dart';

typedef Widget AsyncBlocEventStateBuilder<BlocState>(
    BuildContext context, BlocState state);

class BlocEventStateBuilder<BlocEvent, BlocState> extends StatelessWidget {
  const BlocEventStateBuilder({
    Key key,
    @required this.builder,
    @required this.bloc,
  })  : assert(builder != null),
        assert(bloc != null),
        super(key: key);

  final BlocEventStateBase<BlocEvent, BlocState> bloc;
  final AsyncBlocEventStateBuilder<BlocState> builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BlocState>(
      stream: bloc.state,
      initialData: bloc.initialState,
      builder: (BuildContext context, AsyncSnapshot<BlocState> snapshot) {
        return builder(context, snapshot.data);
      },
    );
  }
}
