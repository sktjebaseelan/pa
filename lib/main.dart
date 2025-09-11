import 'package:expense_tracker/cubit/credential_cubit.dart';
import 'package:expense_tracker/cubit/employee_cubit.dart';
import 'package:expense_tracker/cubit/navigation_cubit.dart';
import 'package:expense_tracker/models/credential.dart';
import 'package:expense_tracker/models/employee.dart';
import 'package:expense_tracker/models/lead.dart';
import 'package:expense_tracker/repositories/credential_repository.dart';
import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/account.dart';
import 'models/expense.dart';
import 'blocs/account_bloc.dart';
import 'blocs/expense_bloc.dart';
import 'blocs/sync_bloc.dart';
import 'repositories/database_repository.dart';
import 'repositories/firebase_repository.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CredentialTypeAdapter());
  Hive.registerAdapter(BankCredentialAdapter());
  Hive.registerAdapter(AadhaarCredentialAdapter());
  Hive.registerAdapter(PanCredentialAdapter());
  Hive.registerAdapter(EmailCredentialAdapter());
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(LeadAdapter());
  Hive.registerAdapter(LeadStatusAdapter());

  await Hive.openBox<Employee>('employees');
  await Hive.openBox<Lead>('leads');
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeBox = Hive.box<Employee>('employees');
    final leadBox = Hive.box<Lead>('leads');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => EmployeeCubit(employeeBox)),
        BlocProvider(create: (_) => LeadCubit(leadBox)),
        BlocProvider<AccountBloc>(
          create: (context) =>
              AccountBloc(databaseRepository: DatabaseRepository())
                ..add(LoadAccounts()),
        ),
        BlocProvider<ExpenseBloc>(
          create: (context) =>
              ExpenseBloc(databaseRepository: DatabaseRepository())
                ..add(LoadExpenses()),
        ),
        BlocProvider<CredentialCubit>(
          create: (context) => CredentialCubit(CredentialRepository())..load(),
        ),

        BlocProvider<SyncBloc>(
          create: (context) => SyncBloc(
            databaseRepository: DatabaseRepository(),
            firebaseRepository: FirebaseRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DashboardScreen(),
      ),
    );
  }
}
