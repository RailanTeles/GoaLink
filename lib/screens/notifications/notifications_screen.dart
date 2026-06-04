import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/screens/notifications/notifications_view_model.dart';
import 'package:goalink/screens/notifications/widgets/notification_card.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosIniciais();
    });
  }

  Future<void> _carregarDadosIniciais() async {
    final vm = context.read<NotificationsViewModel>();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await vm.carregarNotificacoes(uid);

    await vm.marcarComoLidas();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationsViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: _buildBodyContent(vm),
    );
  }

  Widget _buildBodyContent(NotificationsViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularLoading());
    }

    if (vm.erro != null) {
      return RefreshIndicator(
        onRefresh: _carregarDadosIniciais,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Text(
                  '${vm.erro}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (vm.notificacoes?.isEmpty == true) {
      return const Center(
        child: Text(
          'Nenhuma notificação encontrada',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: vm.notificacoes!.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final notification = vm.notificacoes![index];

        return NotificationCard(notification: notification);
      },
    );
  }
}
