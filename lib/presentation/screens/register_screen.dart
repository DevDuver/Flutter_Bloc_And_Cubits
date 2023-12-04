import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/register_cubit/register_cubit.dart';
import 'package:forms_app/presentation/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo usuario'),
      ),
      body: BlocProvider(
        create: (context) => RegisterCubit(),
        child: const _RegisterView(),
      ) 
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: 	SingleChildScrollView(
          child: Column(
            children: [
              FlutterLogo(size: 100),

              _RegisterForm(),

              SizedBox(height: 20),

              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final registerCubit = context.watch<RegisterCubit>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          
          CustomTextFormField(
            label: 'Nombre de usuario',
            onChange: (value) {
              registerCubit.usernameChanged(value);
              _formKey.currentState?.validate();
            },
            validator: (value) {
              if ( value == null || value.isEmpty ) return 'El nombre de usuario es requerido';
              if ( value.trim().isEmpty ) return 'El nombre de usuario es requerido';
              if ( value.trim().length < 6 ) return 'El nombre de usuario debe tener mas de 6 letras';
              return null;
            },
          ),
          
          const SizedBox(height: 10),
          
          CustomTextFormField(
            label: 'Correo eléctronico',
            onChange: (value) {
              registerCubit.emailChanged(value);
              _formKey.currentState?.validate();
            },
            validator: (value) {
              if ( value == null || value.isEmpty ) return 'El correo es requerido';
              if ( value.trim().isEmpty ) return 'El correo es requerido';
              
              final emailRegExp = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              );
              if ( !emailRegExp.hasMatch(value) ) return 'Este correo no es valido';

              return null;
            },
          ),

          const SizedBox(height: 10),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChange:  (value) {
              registerCubit.passwordChanged(value);
              _formKey.currentState?.validate();
            },
            validator: (value) {
              if ( value == null || value.isEmpty ) return 'La contraseña es requerida';
              if ( value.trim().isEmpty ) return 'La contraseña es requerida';
              if ( value.trim().length < 6 ) return 'La contraseña debe tener mas de 6 letras';

              return null;
            },
          ),

          const SizedBox(height: 20),

          FilledButton.tonalIcon(
            onPressed: () {
              // final bool isValid = _formKey.currentState!.validate();
              // if (!isValid) return;

              registerCubit.onSubmit();
            }, 
            icon: const Icon(Icons.save),
            label: const Text('Crear usuario'),
          ),
        ],
      )
    );
  }
}