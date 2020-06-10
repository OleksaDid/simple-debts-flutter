import 'package:flutter/material.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/widgets/common/user_search/user_search.store.dart';
import 'package:simpledebts/widgets/common/debounce_input.dart';

class UsersSearch extends StatelessWidget {
  final _usersStore = UserSearchStore();

  final void Function(User user) onSelectUser;
  final void Function() onCancel;

  UsersSearch({
    @required this.onSelectUser,
    @required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 240,
        ),
        child: Column(
          children: [
            SizedBox(height: 20,),
            DebounceInput(
              inputDecoration: InputDecoration(
                hintText: 'type user name',
              ),
              onInputChange: (name) => _usersStore.getUsersList(context, name),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder<List<User>>(
                    stream: _usersStore.users$,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final users = snapshot.data;

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () => onSelectUser(users[index]),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(users[index].picture),
                                backgroundColor: Colors.white
                              ),
                              title: Text(users[index].name),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  _usersStore.spinnerContainer(
                    spinner: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  )
                ],
              ),
            ),
            FlatButton(
              child: Text('BACK'),
              onPressed: onCancel,
              textColor: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}