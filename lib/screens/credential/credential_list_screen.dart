import 'dart:io';
import 'package:expense_tracker/cubit/credential_cubit.dart';
import 'package:expense_tracker/models/credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_credential_screen.dart';

class CredentialListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Credentials")),
      body: BlocBuilder<CredentialCubit, CredentialState>(
        builder: (context, state) {
          if (state.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.credentials.isEmpty) {
            return Center(child: Text("No credentials stored"));
          }
          return ListView.builder(
            itemCount: state.credentials.length,
            itemBuilder: (context, index) {
              final cred = state.credentials[index];

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  onTap: () {
                    _showDetailDialog(context, cred);
                  },
                  title: Text(
                    cred.type.toString().split('.').last.toUpperCase(),
                  ),
                  subtitle: _buildSubtitle(cred),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<CredentialCubit>().delete(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddCredentialScreen()),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, BaseCredential cred) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${cred.type.toString().split('.').last} Details"),
          content: SingleChildScrollView(child: _buildDetailContent(cred)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailContent(BaseCredential cred) {
    if (cred is BankCredential) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bank Name: ${cred.bankName}"),
          Text("IFSC: ${cred.ifsc}"),
          Text("Account No: ${cred.accountNumber}"),
          Text("Type: ${cred.accountType}"),
          if (cred.passbookImagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.file(File(cred.passbookImagePath!), height: 120),
            ),
        ],
      );
    } else if (cred is AadhaarCredential) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ${cred.name}"),
          Text("Aadhaar No: ${cred.aadhaarNumber}"),
          Text("DOB: ${cred.dob}"),
          if (cred.frontImagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.file(File(cred.frontImagePath!), height: 120),
            ),
          if (cred.backImagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.file(File(cred.backImagePath!), height: 120),
            ),
        ],
      );
    } else if (cred is PanCredential) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ${cred.name}"),
          Text("PAN No: ${cred.panNumber}"),
          Text("DOB: ${cred.dob}"),
        ],
      );
    } else if (cred is EmailCredential) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Username: ${cred.username}"),
          Text("Password: ${cred.password}"),
          Text("Provider: ${cred.provider}"),
        ],
      );
    }
    return Text("Unknown type");
  }

  Widget _buildSubtitle(BaseCredential cred) {
    if (cred is BankCredential) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bank: ${cred.bankName}"),
          Text("Account: ${cred.accountNumber}"),
          if (cred.passbookImagePath != null)
            Image.file(File(cred.passbookImagePath!), height: 80),
        ],
      );
    } else if (cred is AadhaarCredential) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ${cred.name}"),
          Text("Aadhaar: ${cred.aadhaarNumber}"),
          if (cred.frontImagePath != null)
            Image.file(File(cred.frontImagePath!), height: 80),
          if (cred.backImagePath != null)
            Image.file(File(cred.backImagePath!), height: 80),
        ],
      );
    } else if (cred is PanCredential) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Name: ${cred.name}"), Text("PAN: ${cred.panNumber}")],
      );
    } else if (cred is EmailCredential) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email: ${cred.username}"),
          Text("Provider: ${cred.provider}"),
        ],
      );
    }
    return Text("Unknown credential");
  }
}
