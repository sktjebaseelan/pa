import 'dart:io';
import 'package:expense_tracker/cubit/credential_cubit.dart';
import 'package:expense_tracker/models/credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCredentialScreen extends StatefulWidget {
  @override
  _AddCredentialScreenState createState() => _AddCredentialScreenState();
}

class _AddCredentialScreenState extends State<AddCredentialScreen> {
  final _formKey = GlobalKey<FormState>();
  CredentialType _selectedType = CredentialType.bank;

  // Common controllers
  final _field1 = TextEditingController();
  final _field2 = TextEditingController();
  final _field3 = TextEditingController();
  final _field4 = TextEditingController();

  String? _imagePath1;
  String? _imagePath2;

  final picker = ImagePicker();
  Future<void> _pickImage(bool first) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Image Source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text("Gallery"),
          ),
        ],
      ),
    );

    if (source != null) {
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        setState(() {
          if (first) {
            _imagePath1 = picked.path;
          } else {
            _imagePath2 = picked.path;
          }
        });
      }
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<CredentialCubit>();

    switch (_selectedType) {
      case CredentialType.bank:
        cubit.add(
          BankCredential(
            bankName: _field1.text,
            ifsc: _field2.text,
            accountNumber: _field3.text,
            accountType: _field4.text,
            passbookImagePath: _imagePath1,
          ),
        );
        break;
      case CredentialType.aadhaar:
        cubit.add(
          AadhaarCredential(
            name: _field1.text,
            aadhaarNumber: _field2.text,
            dob: _field3.text,
            frontImagePath: _imagePath1,
            backImagePath: _imagePath2,
          ),
        );
        break;
      case CredentialType.pan:
        cubit.add(
          PanCredential(
            name: _field1.text,
            panNumber: _field2.text,
            dob: _field3.text,
          ),
        );
        break;
      case CredentialType.email:
        cubit.add(
          EmailCredential(
            username: _field1.text,
            password: _field2.text,
            provider: _field3.text,
          ),
        );
        break;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Credential")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<CredentialType>(
                value: _selectedType,
                onChanged: (val) => setState(() => _selectedType = val!),
                items: CredentialType.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name.toUpperCase()),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 12),
              ..._buildFields(),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: Text("Save")),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFields() {
    switch (_selectedType) {
      case CredentialType.bank:
        return [
          TextFormField(
            controller: _field1,
            decoration: InputDecoration(labelText: "Bank Name"),
          ),
          TextFormField(
            controller: _field2,
            decoration: InputDecoration(labelText: "IFSC Code"),
          ),
          TextFormField(
            controller: _field3,
            decoration: InputDecoration(labelText: "Account Number"),
          ),
          TextFormField(
            controller: _field4,
            decoration: InputDecoration(labelText: "Account Type"),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(true),
            child: Text("Pick Passbook Image"),
          ),
          if (_imagePath1 != null) Image.file(File(_imagePath1!), height: 100),
        ];
      case CredentialType.aadhaar:
        return [
          TextFormField(
            controller: _field1,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextFormField(
            controller: _field2,
            decoration: InputDecoration(labelText: "Aadhaar Number"),
          ),
          TextFormField(
            controller: _field3,
            decoration: InputDecoration(labelText: "Date of Birth"),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(true),
            child: Text("Pick Front Image"),
          ),
          if (_imagePath1 != null) Image.file(File(_imagePath1!), height: 100),
          ElevatedButton(
            onPressed: () => _pickImage(false),
            child: Text("Pick Back Image"),
          ),
          if (_imagePath2 != null) Image.file(File(_imagePath2!), height: 100),
        ];
      case CredentialType.pan:
        return [
          TextFormField(
            controller: _field1,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextFormField(
            controller: _field2,
            decoration: InputDecoration(labelText: "PAN Number"),
          ),
          TextFormField(
            controller: _field3,
            decoration: InputDecoration(labelText: "Date of Birth"),
          ),
        ];
      case CredentialType.email:
        return [
          TextFormField(
            controller: _field1,
            decoration: InputDecoration(labelText: "Username"),
          ),
          TextFormField(
            controller: _field2,
            decoration: InputDecoration(labelText: "Password"),
          ),
          TextFormField(
            controller: _field3,
            decoration: InputDecoration(labelText: "Provider"),
          ),
        ];
    }
  }
}
