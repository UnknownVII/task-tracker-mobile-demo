import 'package:flutter/material.dart';
import 'package:task_tracker_mobile_demo/Styles/text-styles.dart';

import '../Components/text-input-field.dart';
import '../Models/task_model.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  FocusNode titleFocus = new FocusNode();
  FocusNode descriptionFocus = new FocusNode();
  late TaskCreateRequestModel taskCreateRequestModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Task",
          style: headerTextStyle,
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF072B5A),
      body: Container(
        child: Form(
          key: globalFormKey,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: textFormField(
                  focusNode: titleFocus,
                  onTap: _requestFocusTitle,
                  keyboardType: TextInputType.emailAddress,
                  keyboardAction: TextInputAction.next,
                  onSaved: (input) => taskCreateRequestModel.title = input!,
                  validator: (input) => !input!.contains("@") ? "Email Address invalid" : null,
                  label: 'Title',
                  maxLength: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 180,
                child: textFormField(
                  focusNode: descriptionFocus,
                  onTap: _requestFocusDescription,
                  keyboardType: TextInputType.multiline,
                  keyboardAction: TextInputAction.done,
                  onSaved: (input) => taskCreateRequestModel.description = input!,
                  validator: (input) => input!.length < 6 ? "Password is less than 6 characters" : null,
                  label: 'Description',
                  maxLength: 250,
                  maxLine: 10,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
                child: textFormField(
                  focusNode: descriptionFocus,
                  onTap: _requestFocusDescription,
                  keyboardType: TextInputType.datetime,
                  keyboardAction: TextInputAction.done,
                  onSaved: (input) => taskCreateRequestModel.dueDate = input!,
                  validator: (input) => input!.length < 6 ? "Password is less than 6 characters" : null,
                  label: 'DueDate',
                  prefix: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                  suffix: IconButton(
                    onPressed: () {
                        
                    },
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _requestFocusTitle() {
    setState(() {
      FocusScope.of(context).requestFocus(titleFocus);
    });
  }

  void _requestFocusDescription() {
    setState(() {
      FocusScope.of(context).requestFocus(descriptionFocus);
    });
  }
}
