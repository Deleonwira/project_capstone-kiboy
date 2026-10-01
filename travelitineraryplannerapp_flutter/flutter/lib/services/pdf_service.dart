import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/itinerary.dart';
import '../models/activity.dart';
import '../models/expense.dart';

class PdfService {
  static Future<void> printItinerary({
    required Itinerary itinerary,
    required List<Activity> activities,
    required List<Expense> expenses,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Travel Itinerary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Text(itinerary.title, style: pw.TextStyle(fontSize: 20)),
            pw.Text('Destinasi: ${itinerary.destination}'),
            pw.Text('Tanggal: ${itinerary.startDate} s/d ${itinerary.endDate}'),
            pw.SizedBox(height: 20),
            
            pw.Header(level: 1, text: 'Jadwal Aktivitas'),
            activities.isEmpty 
              ? pw.Text('- Belum ada jadwal -')
              : pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Tanggal', 'Waktu', 'Aktivitas', 'Catatan'],
                    ...activities.map((a) => [a.date, a.time, a.title, a.description])
                  ],
                ),
            pw.SizedBox(height: 20),
            
            pw.Header(level: 1, text: 'Budget / Pengeluaran'),
            expenses.isEmpty
              ? pw.Text('- Belum ada pengeluaran -')
              : pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Kategori', 'Item', 'Harga'],
                    ...expenses.map((e) => [e.category, e.title, e.amount.toStringAsFixed(2)])
                  ],
                ),
            
            if (expenses.isNotEmpty) ...[
              pw.SizedBox(height: 10),
              pw.Text(
                'Total Pengeluaran: ${expenses.map((e) => e.amount).reduce((a, b) => a + b).toStringAsFixed(2)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              )
            ]
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${itinerary.title.replaceAll(' ', '_')}_itinerary.pdf',
    );
  }
}
