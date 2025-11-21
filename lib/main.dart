import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? dogImageUrl;
  bool loading = false;

  Future<void> getDogImage() async {
    setState(() => loading = true);

    final url = Uri.parse("https://dog.ceo/api/breeds/image/random");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          dogImageUrl = jsonData["message"];
        });
      } else {
        debugPrint("ERRO: status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Erro: $e");
    }

    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    getDogImage(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Gerador de Fotos de Cachorros"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading
                ? const CircularProgressIndicator(color: Color.fromARGB(255, 255, 255, 255))
                : dogImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          dogImageUrl!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Text(
                        "Nenhuma imagem carregada",
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getDogImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                "Gerar cachorro aleatório",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
