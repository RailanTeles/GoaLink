import 'package:flutter/material.dart';
import 'package:goalink/screens/profile/widgets/perfil_header_widget.dart';
import 'package:goalink/screens/profile/widgets/informacoes_pessoais_widget.dart';
import 'package:goalink/screens/profile/widgets/redes_sociais_widget.dart';
import 'package:goalink/screens/profile/widgets/descricao_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double alturaContainer = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          alturaContainer = 600.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Header com foto e nome do perfil
                          const PerfilHeaderWidget(),
                          
                          const SizedBox(height: 20),
                          
                          // Painel inferior com todas as informações
                          PainelInferiorPerfil(alturaContainer: alturaContainer),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PainelInferiorPerfil extends StatelessWidget {
  final double alturaContainer;

  const PainelInferiorPerfil({
    super.key,
    required this.alturaContainer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      height: alturaContainer,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações pessoais
              const InformacoesPessoaisWidget(),
              
              const SizedBox(height: 20),
              
              // Redes sociais
              const RedesSociaisWidget(),
              
              const SizedBox(height: 20),
              
              // Descrição
              const DescricaoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}