import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de data
import '../utils/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _historyData;

  @override
  void initState() {
    super.initState();
    _historyData = _fetchHistory();
  }

  // Método para carregar o histórico do banco de dados
  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final dbHelper = DataBaseHelper();
    return await dbHelper.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Chamadas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum histórico encontrado.'));
          } else {
            final historyList = snapshot.data!;
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final historyItem = historyList[index];
                final qrCodeLink = historyItem['qrCodeLink'];
                final timestamp = DateTime.parse(historyItem['timestamp']);
                final formattedTimestamp =
                    DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp);

                return ListTile(
                  title: Text(qrCodeLink),
                  subtitle: Text('Data: $formattedTimestamp'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
