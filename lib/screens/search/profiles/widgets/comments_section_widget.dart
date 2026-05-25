import 'package:flutter/material.dart';
import 'package:goalink/models/avaliacao_model.dart';
import 'package:goalink/screens/profile/profile_view_model.dart';
import 'package:provider/provider.dart';

class CommentsSectionWidget extends StatefulWidget {
  const CommentsSectionWidget({super.key, required this.avaliacoes});

  final List<AvaliacaoModel> avaliacoes;

  @override
  State<CommentsSectionWidget> createState() => _CommentsSectionWidgetState();
}

class _CommentsSectionWidgetState extends State<CommentsSectionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    if (vm.isLoadingAvaliacoes) {
      return const CircularProgressIndicator();
    }
    return Column(
      crossAxisAlignment: .start,
      children: [
        // TODO: Implementar fazer comentário posteriormente
        // TextField(
        //   decoration: InputDecoration(
        //     hintText: 'Fazer comentário',
        //     prefixIcon: Icon(
        //       Icons.mode_comment_outlined,
        //       color: Theme.of(context).primaryColor,
        //     ),
        //     contentPadding: const EdgeInsets.symmetric(
        //       horizontal: 12,
        //       vertical: 14,
        //     ),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //   ),
        // ),
        // const SizedBox(height: 12),
        // FutureBuilder<List<AvaliacaoModel>>(
        //   future: _futuroAvaliacoes,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: SizedBox(
        //           width: 40,
        //           height: 40,
        //           child: CircularProgressIndicator(
        //             color: Theme.of(context).primaryColor,
        //             strokeWidth: 4.0,
        //           ),
        //         ),
        //       );
        //     }

        //     if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //       return const SizedBox(
        //         width: double.infinity,
        //         height: 300,
        //         child: Center(
        //           child: Text(
        //             "Esse usuário não fez nenhum comentário ainda",
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               fontSize: 16,
        //               fontWeight: FontWeight.w500,
        //               color: Colors.grey,
        //             ),
        //           ),
        //         ),
        //       );
        //     }

        //     final comentarios = snapshot.data!;

        //     return ListView.builder(
        //       shrinkWrap: true,
        //       padding: EdgeInsets.zero,
        //       physics: const NeverScrollableScrollPhysics(),
        //       itemCount: comentarios.length,
        //       itemBuilder: (context, index) {
        //         final comentario = comentarios[index];

        //         return Container(
        //           margin: const EdgeInsets.only(bottom: 12),
        //           padding: const EdgeInsets.all(12),
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(12),
        //             border: Border.all(color: Colors.black12),
        //           ),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               FutureBuilder<UsuarioModel?>(
        //                 future: _getAutorById(comentario.autorId),
        //                 builder: (context, autorSnapshot) {
        //                   if (autorSnapshot.connectionState ==
        //                       ConnectionState.waiting) {
        //                     return const Row(
        //                       children: [
        //                         SizedBox(
        //                           width: 36,
        //                           height: 36,
        //                           child: CircularProgressIndicator(
        //                             strokeWidth: 2,
        //                           ),
        //                         ),
        //                         SizedBox(width: 10),
        //                         Text(
        //                           "Carregando...",
        //                           style: TextStyle(color: Colors.grey),
        //                         ),
        //                       ],
        //                     );
        //                   }

        //                   if (!autorSnapshot.hasData ||
        //                       autorSnapshot.data == null) {
        //                     return const Row(
        //                       children: [
        //                         Icon(
        //                           Icons.account_circle,
        //                           size: 36,
        //                           color: Colors.grey,
        //                         ),
        //                         SizedBox(width: 10),
        //                         Text(
        //                           "Usuário desconhecido",
        //                           style: TextStyle(color: Colors.grey),
        //                         ),
        //                       ],
        //                     );
        //                   }

        //                   final autor = autorSnapshot.data!;

        //                   return Row(
        //                     children: [
        //                       AvatarUsuario(
        //                         urlFoto: autor.fotoPerfil,
        //                         tamanho: 36,
        //                       ),
        //                       const SizedBox(width: 10),
        //                       Expanded(
        //                         child: Text(
        //                           autor.nome,
        //                           maxLines: 1,
        //                           overflow: TextOverflow.ellipsis,
        //                           style: const TextStyle(
        //                             fontWeight: FontWeight.w600,
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   );
        //                 },
        //               ),
        //               const SizedBox(height: 10),
        //               Text(
        //                 comentario.texto,
        //                 style: const TextStyle(height: 1.35),
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ),
      ],
    );
  }
}
