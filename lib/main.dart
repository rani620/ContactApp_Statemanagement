import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      // for routing to the next  page . after clicking the submit  page
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
    );
  }
}

class Contact {
  final String id;
  final String name;

  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}
// cOnvert cntact book to value notifier

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance()
      : super([Contact(name: 'hello Rani ')]); // it is an array

  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  // final List<Contact> _contacts = [
  //   //const Contact(name:'Foo bar')
  // ];

  int get length => value.length;

  void add({required Contact contact}) {
    // final ValueNotifier notifier;

    // value.add(contact);

    ////This is one way and another way is also to write this.

    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void remove({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      // value = contacts;
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ValueListenableBuilder(
          valueListenable: ContactBook(),
          builder: (context, value, child) {
            final contacts = value as List<Contact>;

            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Dismissible(
                  onDismissed: (direction) {
                    contacts.remove(contact);
                  },
                  key: ValueKey(contact.id),
                  child: Material(
                    color: Colors.white,
                    elevation: 6.0,
                    child: ListTile(
                      title: Text(contact.name),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // next step of routing in the
          Navigator.of(context).pushNamed('/new-contact');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(); // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new contact '),
      ),
      body: Column(children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter a new contact name ',
          ),
        ),
        TextButton(
            onPressed: () {
              final contact = Contact(name: _controller.text);
              ContactBook().add(contact: contact);
              Navigator.of(context).pop();
            },
            child: Text(
              'Add Contact',
            ))
      ]),
    );
  }
}
