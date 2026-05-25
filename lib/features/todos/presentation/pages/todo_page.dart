import 'package:flutter/material.dart';
import 'package:nuzagizi/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nuzagizi/features/auth/presentation/pages/login_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _todoController = TextEditingController();
  final AuthRemoteDataSource _authService = AuthRemoteDataSource();
  bool _isLoading = false;

  Future<void> _submitTodo() async {
    final title = _todoController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Todo tidak boleh kosong')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.createTodoWithDio(title);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menambahkan Todo!')),
        );
        _todoController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menambahkan Todo: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal logout: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Future<void> _handleGoogleLogin() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final credentials = await _authService.auth0
  //         .webAuthentication(scheme: 'nusagizi')
  //         .login(
  //           audience: 'https://api.nuzagizi.com',
  //           parameters: {'connection': 'google-oauth2'},
  //         );

  //     await _authService.auth0.credentialsManager.storeCredentials(credentials);

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Berhasil masuk dengan Google!')),
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('Login dibatalkan: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Gagal login Google: $e')));
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Todo'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _handleLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'Nama Todo',
                hintText: 'Contoh: Mengerjakan tugas akhir',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submitTodo(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitTodo,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Tambah Todo'),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Atau"),
          ],
        ),
      ),
    );
  }
}
