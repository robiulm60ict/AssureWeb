// // lib/configs/pdf/pdf_web.dart
//
// import 'dart:html' as html show Blob, Url, AnchorElement;
// import 'dart:typed_data';
//
// Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
//   final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
//   final url = html.Url.createObjectUrlFromBlob(blob);
//
//   // Create an anchor element to download the file
//   final anchor = html.AnchorElement(href: url)
//     ..setAttribute('download', '$fileName.pdf')
//     ..click();
//
//   // Release the object URL after usage
//   html.Url.revokeObjectUrl(url);
//
//   print('File created and download started: $fileName.pdf');
// }
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
Future<void> savePdfWeb( Map<String, dynamic> buildingSaleData) async {
  final pdf = pw.Document();
  final buildingSale = buildingSaleData["buildingSale"];
  final building = buildingSaleData["building"];
  pdf.addPage(
    pw.MultiPage(
      header: (context) => pw.Column(
        children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.SizedBox(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    "ASSURE GROUP",
                    style: pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "ASSURE DEVELOPMENT & LTD.",
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Sales Particulars",
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ]),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                "Date :",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(width: 4),
              pw.Text(
                DateFormat('dd-MM-yyyy').format((buildingSale['BookingDate'] as Timestamp).toDate()),
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
      footer: (context) => pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("-----------------"),
              pw.Text("--------------------------"),
              pw.Text("--------------------------------"),
            ],
          ),
          // pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Sales Person"),
              pw.Text("Customer Signature"),
              pw.Text("Head of Marketing Sales"),
            ],
          ),
        ],
      ),
      build: (context) => [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "1.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "Prospect's Name",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Text(
              ": ${building['prospectName']} ",
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "2.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "Project Name",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Text(
              ": ${building['projectName']} ",
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "3.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "Project Address",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Text(
              ": ${building['projectAddress']} ",
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "4.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "Floor No",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Text(
              ": ${building['floorNo']} ",
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "5.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "Apartment Size",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Text(
              ": ${building['appointmentSize']} ",
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "6.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "Hand Over Time",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Text(
              ": ${buildingSale['handoverDate']} ",
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "7.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "Total Price",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Text(
              ": ${building['totalCost']} ",
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                pw.Container(
                  width: 100, // Adjust width as needed
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Description')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Tk.')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Amount')),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Container(
                  width: 100, // Adjust width as needed
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Per Sft. Price')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Tk.')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child:
                  pw.Center(child: pw.Text('${building['perSftPrice']}')),
                ),
              ],
            ),

            pw.TableRow(
              children: [
                pw.Container(
                  width: 100, // Adjust width as needed
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Total Units Price')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Tk.')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(
                      child: pw.Text('${building['totalUnitPrice']}')),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Container(
                  width: 100, // Adjust width as needed
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Car Parking')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Tk.')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child:
                  pw.Center(child: pw.Text('${building['carParking']}')),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Container(
                  width: 100, // Adjust width as needed
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Utility Cost')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Tk.')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('${building['unitCost']}')),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Container(
                  width: 100, // Adjust width as needed
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Total Unit Value')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Tk.')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child:
                  pw.Center(child: pw.Text('${building['totalCost']}')),
                ),
              ],
            ),
            // Add additional TableRow widgets here for more rows
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "8.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              // width: 150,
              child: pw.Text(
                "Booking Money + Down Payment :",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                pw.Container(
                  width: 100, // Adjust width as needed
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Payment Schedule')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(child: pw.Text('Date')),
                ),
              ],
            ),

            pw.TableRow(
              children: [
                pw.Container(
                  width: 100, // Adjust width as needed
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(
                      child: pw.Text(
                          'Booking + Down Payment ${buildingSale['bookingPaymentPercent']} % ${buildingSale['bookDownPayment'] ?? ""}')),
                ),
                pw.Container(
                  width: 50,
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Center(
                    child: pw.Text(
                      DateFormat('dd-MM-yyyy').format((buildingSale['BookingDate'] as Timestamp).toDate()),
                    ),
                  ),
                ),

              ],
            ),

            // Add additional TableRow widgets here for more rows
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 20,
              child: pw.Text(
                "9.",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              // width: 150,
              child: pw.Text(
                "Installment Schedule :",
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            // Header row
            pw.TableRow(
              children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Installment')),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Amount(Schedule)')),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Date')),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Status')),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Remarks')),
              ],
            ),
            // Data rows
            ...List<pw.TableRow>.generate(
              buildingSale['installmentPlan'].length,
                  (index) {
                var installment = buildingSale['installmentPlan'][index];
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('${installment['id']} Installment'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('${installment['amount']}'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('${installment['dueDate']}'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('${installment['status']}'),
                    ),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('', textAlign: pw.TextAlign.center)),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    ),
  );

  final data = await pdf.save();

  final blob = html.Blob([data], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'document.pdf')
    ..click();
  html.Url.revokeObjectUrl(url);
}
